import Foundation

public struct SetupCoordinator: Sendable {
    let configPath: String?
    let defaultConfigPath: String

    public init(configPath: String?, defaultConfigPath: String = SetupHelper.defaultConfigPath) {
        self.configPath = configPath
        self.defaultConfigPath = defaultConfigPath
    }

    public func runCLIFlow(token: String?) async throws {
        let baseConfig = try await loadConfigForSetup()
        let tokenValue = try await resolveToken(provided: token)
        do {
            var updated = baseConfig
            updated.userToken = tokenValue
            let url = try SetupHelper.persistConfig(updated, configPath: configPath, defaultPath: defaultConfigPath)
            print("Saved Music-User-Token to \(url.path) with permissions 0600.")
            print("You can now start apple-music-mcp.")
        } catch {
            let message = "Failed to persist user token: \(error.localizedDescription)\n"
            FileHandle.standardError.write(Data(message.utf8))
            throw error
        }
    }

    public func runServerFlow(port: UInt16 = 3000) async throws {
        let config = try await loadConfigForSetup()
        let developerToken = try DeveloperTokenProvider().token(using: config)

        let tokenStream = AsyncStream<Void>.makeStream()
        let server = SetupServer(port: port, developerToken: developerToken) { token in
            do {
                var updated = config
                updated.userToken = token
                let url = try SetupHelper.persistConfig(updated, configPath: configPath, defaultPath: defaultConfigPath)
                print("Saved Music-User-Token to \(url.path) with permissions 0600.")
                print("You can now start apple-music-mcp.")
            } catch {
                let message = "Failed to persist user token: \(error.localizedDescription)\n"
                FileHandle.standardError.write(Data(message.utf8))
            }
            tokenStream.continuation.yield(())
            tokenStream.continuation.finish()
        }

        try server.start()
        server.openInBrowser()
        print("Listening on http://127.0.0.1:\(port) — your browser will request authorization and the token will be saved automatically.")

        for await _ in tokenStream.stream {
            break
        }
        server.stop()
    }

    private func loadConfigForSetup() async throws -> AppConfig {
        var config = SetupHelper.loadConfig(at: SetupHelper.configURL(overridePath: configPath, defaultPath: defaultConfigPath))
        let env = ProcessInfo.processInfo.environment
        config.teamID = try requiredEnv("APPLE_MUSIC_TEAM_ID", env: env)
        config.musicKitKeyID = try requiredEnv("APPLE_MUSIC_MUSICKIT_ID", env: env)
        config.privateKey = try requiredEnv("APPLE_MUSIC_PRIVATE_KEY", env: env)
        return config
    }

    private func resolveToken(provided: String?) async throws -> String {
        if let provided {
            return provided
        }

        print("Enter your Music-User-Token (paste and press Return):", terminator: " ")
        guard let line = readLine(strippingNewline: true) else {
            throw SetupError.emptyToken
        }
        return line
    }

    private func requiredEnv(_ key: String, env: [String: String]) throws -> String {
        guard let raw = env[key]?.trimmingCharacters(in: .whitespacesAndNewlines), !raw.isEmpty else {
            throw SetupError.missingEnvironmentVariable(key)
        }
        return raw
    }
}

import Foundation

struct SetupCoordinator {
    let configPath: String?

    init(configPath: String?) {
        self.configPath = configPath
    }

    func runCLIFlow(token: String?) async throws {
        let tokenValue = try await resolveToken(provided: token)
        do {
            let url = try SetupHelper.persistUserToken(tokenValue, configPath: configPath)
            print("Saved Music-User-Token to \(url.path) with permissions 0600.")
            print("You can now start AppleMusicMCPServer.")
        } catch {
            let message = "Failed to persist user token: \(error.localizedDescription)\n"
            FileHandle.standardError.write(Data(message.utf8))
            throw error
        }
    }

    func runServerFlow(port: UInt16 = 3000) async throws {
        let config = try loadConfigForSetup()
        let developerToken = try DeveloperTokenProvider().token(using: config)

        let tokenStream = AsyncStream<Void>.makeStream()
        let server = SetupServer(port: port, developerToken: developerToken) { token in
            do {
                let url = try SetupHelper.persistUserToken(token, configPath: configPath)
                print("Saved Music-User-Token to \(url.path) with permissions 0600.")
                print("You can now start AppleMusicMCPServer.")
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

    private func loadConfigForSetup() throws -> AppConfig {
        let env = ProcessInfo.processInfo.environment
        let url = SetupHelper.configURL(env: env, overridePath: configPath)
        let fileConfig = SetupHelper.loadConfig(at: url)
        return AppConfig(
            teamID: env["APPLE_MUSIC_TEAM_ID"] ?? fileConfig.teamID,
            musicKitKeyID: env["APPLE_MUSIC_MUSICKIT_ID"] ?? env["APPLE_MUSIC_MUSICKIT_KEY_ID"] ?? fileConfig.musicKitKeyID,
            privateKey: env["APPLE_MUSIC_PRIVATE_KEY_P8"] ?? env["APPLE_MUSIC_PRIVATE_KEY"] ?? fileConfig.privateKey,
            privateKeyPath: env["APPLE_MUSIC_PRIVATE_KEY_PATH"] ?? fileConfig.privateKeyPath,
            bundleID: env["APPLE_MUSIC_BUNDLE_ID"] ?? fileConfig.bundleID,
            userToken: fileConfig.userToken
        )
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
}

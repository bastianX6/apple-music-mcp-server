import Configuration
import Foundation
import SystemPackage

struct ConfigLoader {
    private let fileManager = FileManager.default
    private let overrideConfigPath: String?
    private let defaultConfigPath = "~/Library/Application Support/apple-music-mcp/config.json"

    init(configPath: String? = nil) {
        self.overrideConfigPath = configPath
    }

    func load() async throws -> AppConfig {
        let env = ProcessInfo.processInfo.environment
        let configURL = resolveConfigURL(env: env)
        let providers = try await makeProviders(configURL: configURL)
        let reader = ConfigReader(providers: providers)

        let teamID = configValue([
            "APPLE_MUSIC_TEAM_ID",
            "appleMusic.teamId"
        ], reader: reader)
        let musicKitKeyID = configValue([
            "APPLE_MUSIC_MUSICKIT_ID",
            "appleMusic.musicKitKeyId"
        ], reader: reader)
        let privateKey = configValue([
            "APPLE_MUSIC_PRIVATE_KEY",
            "appleMusic.privateKey"
        ], reader: reader)
        let userToken = configValue([
            "APPLE_MUSIC_USER_TOKEN",
            "appleMusic.userToken"
        ], reader: reader)

        return AppConfig(
            teamID: teamID,
            musicKitKeyID: musicKitKeyID,
            privateKey: privateKey,
            userToken: userToken
        )
    }

    private func resolveConfigURL(env: [String: String]) -> URL {
        let chosen = overrideConfigPath ?? env["APPLE_MUSIC_CONFIG_PATH"] ?? defaultConfigPath
        let expanded = (chosen as NSString).expandingTildeInPath
        return URL(fileURLWithPath: expanded)
    }

    private func makeProviders(configURL: URL) async throws -> [any ConfigProvider] {
        var providers: [any ConfigProvider] = [EnvironmentVariablesProvider()]

        if fileManager.fileExists(atPath: configURL.path) {
            try enforce0600Permissions(at: configURL)
            let fileProvider = try await FileProvider<JSONSnapshot>(filePath: FilePath(configURL.path))
            providers.append(fileProvider)
        }

        return providers
    }

    private func enforce0600Permissions(at url: URL) throws {
        let attrs = try fileManager.attributesOfItem(atPath: url.path)
        if let posixPermissions = attrs[.posixPermissions] as? NSNumber {
            let mode = posixPermissions.intValue
            let ownerReadWriteOnly = (mode & 0o077) == 0
            if !ownerReadWriteOnly {
                throw NSError(domain: "ConfigLoader", code: 1, userInfo: [NSLocalizedDescriptionKey: "Config file permissions must be 0600."])
            }
        }
    }

    private func trimmed(_ value: String?) -> String? {
        guard let value else { return nil }
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    private func configValue(_ keys: [String], reader: ConfigReader) -> String? {
        for key in keys {
            let configKey = ConfigKey(stringLiteral: key)
            if let value = trimmed(reader.string(forKey: configKey)) {
                return value
            }
        }
        return nil
    }
}

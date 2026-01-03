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
        let configURL = resolveConfigURL()
        let providers = try await makeProviders(configURL: configURL)
        let reader = ConfigReader(providers: providers)

        let teamID = configValue([
            "appleMusic.teamId",
            "teamID",
            "APPLE_MUSIC_TEAM_ID"
        ], reader: reader)
        let musicKitKeyID = configValue([
            "appleMusic.musicKitKeyId",
            "musicKitKeyID",
            "APPLE_MUSIC_MUSICKIT_ID"
        ], reader: reader)
        let privateKey = configValue([
            "appleMusic.privateKey",
            "privateKey",
            "APPLE_MUSIC_PRIVATE_KEY"
        ], reader: reader)
        let userToken = configValue([
            "appleMusic.userToken",
            "userToken",
            "APPLE_MUSIC_USER_TOKEN"
        ], reader: reader)

        return AppConfig(
            teamID: teamID,
            musicKitKeyID: musicKitKeyID,
            privateKey: privateKey,
            userToken: userToken
        )
    }

    private func resolveConfigURL() -> URL {
        let chosen = overrideConfigPath ?? defaultConfigPath
        let expanded = (chosen as NSString).expandingTildeInPath
        return URL(fileURLWithPath: expanded)
    }

    private func makeProviders(configURL: URL) async throws -> [any ConfigProvider] {
        guard fileManager.fileExists(atPath: configURL.path) else {
            throw ServerError.missingConfigFile(configURL.path)
        }

        try enforce0600Permissions(at: configURL)
        let fileProvider = try await FileProvider<JSONSnapshot>(filePath: FilePath(configURL.path))
        return [fileProvider]
    }

    private func enforce0600Permissions(at url: URL) throws {
        let attrs = try fileManager.attributesOfItem(atPath: url.path)
        if let posixPermissions = attrs[.posixPermissions] as? NSNumber {
            let mode = posixPermissions.intValue
            let ownerReadWriteOnly = (mode & 0o077) == 0
            if !ownerReadWriteOnly {
                throw ServerError.invalidConfigPermissions
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

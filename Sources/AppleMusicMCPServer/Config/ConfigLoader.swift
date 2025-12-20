import Foundation

struct ConfigLoader {
    private let fileManager = FileManager.default
    private let configPath = "~/.mcp/AppleMusicMCPServer/configs/config.json"

    func load() throws -> AppConfig {
        let fileConfig = try loadFileConfig()
        return AppConfig(
            teamID: env("APPLE_MUSIC_TEAM_ID") ?? fileConfig.teamID,
            musicKitKeyID: env("APPLE_MUSIC_MUSICKIT_ID") ?? env("APPLE_MUSIC_MUSICKIT_KEY_ID") ?? fileConfig.musicKitKeyID,
            privateKey: env("APPLE_MUSIC_PRIVATE_KEY_P8") ?? env("APPLE_MUSIC_PRIVATE_KEY") ?? fileConfig.privateKey,
            privateKeyPath: env("APPLE_MUSIC_PRIVATE_KEY_PATH") ?? fileConfig.privateKeyPath,
            bundleID: env("APPLE_MUSIC_BUNDLE_ID") ?? fileConfig.bundleID,
            userToken: fileConfig.userToken
        )
    }

    private func loadFileConfig() throws -> AppConfig {
        let expandedPath = (configPath as NSString).expandingTildeInPath
        guard fileManager.fileExists(atPath: expandedPath) else { return AppConfig() }

        // Enforce user-only permissions (0600) on the config file.
        let attrs = try fileManager.attributesOfItem(atPath: expandedPath)
        if let posixPermissions = attrs[.posixPermissions] as? NSNumber {
            let mode = posixPermissions.intValue
            let ownerReadWriteOnly = (mode & 0o077) == 0
            if !ownerReadWriteOnly {
                throw NSError(domain: "ConfigLoader", code: 1, userInfo: [NSLocalizedDescriptionKey: "Config file permissions must be 0600."])
            }
        }

        let data = try Data(contentsOf: URL(fileURLWithPath: expandedPath))
        return try JSONDecoder().decode(AppConfig.self, from: data)
    }

    private func env(_ key: String) -> String? {
        ProcessInfo.processInfo.environment[key]
    }
}

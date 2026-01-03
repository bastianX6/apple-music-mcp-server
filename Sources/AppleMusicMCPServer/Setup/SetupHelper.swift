import Foundation

struct SetupHelper {
    private static let defaultConfigPath = "~/Library/Application Support/apple-music-mcp/config.json"

    static func configURL(env: [String: String] = ProcessInfo.processInfo.environment, overridePath: String? = nil) -> URL {
        let override = overridePath ?? env["APPLE_MUSIC_CONFIG_PATH"] ?? defaultConfigPath
        let expanded = (override as NSString).expandingTildeInPath
        return URL(fileURLWithPath: expanded)
    }

    @discardableResult
    static func persistConfig(
        _ config: AppConfig,
        configPath: String? = nil,
        env: [String: String] = ProcessInfo.processInfo.environment
    ) throws -> URL {
        var sanitized = AppConfig(
            teamID: config.teamID?.trimmingCharacters(in: .whitespacesAndNewlines),
            musicKitKeyID: config.musicKitKeyID?.trimmingCharacters(in: .whitespacesAndNewlines),
            privateKey: config.privateKey?.trimmingCharacters(in: .whitespacesAndNewlines),
            userToken: config.userToken?.trimmingCharacters(in: .whitespacesAndNewlines)
        )

        if sanitized.userToken == "" { sanitized.userToken = nil }
        if sanitized.teamID == "" { sanitized.teamID = nil }
        if sanitized.musicKitKeyID == "" { sanitized.musicKitKeyID = nil }
        if sanitized.privateKey == "" { sanitized.privateKey = nil }

        if let token = sanitized.userToken, token.isEmpty {
            throw SetupError.emptyToken
        }

        let url = configURL(env: env, overridePath: configPath)
        let existing = loadConfig(at: url)
        var merged = existing
        if let teamID = sanitized.teamID { merged.teamID = teamID }
        if let musicKitKeyID = sanitized.musicKitKeyID { merged.musicKitKeyID = musicKitKeyID }
        if let privateKey = sanitized.privateKey { merged.privateKey = privateKey }
        if let userToken = sanitized.userToken { merged.userToken = userToken }

        try writeConfig(merged, to: url)
        try enforce0600Permissions(at: url)
        return url
    }

    static func loadConfig(at url: URL) -> AppConfig {
        let fm = FileManager.default
        guard fm.fileExists(atPath: url.path) else { return AppConfig() }
        guard let data = try? Data(contentsOf: url), let decoded = try? JSONDecoder().decode(AppConfig.self, from: data) else {
            return AppConfig()
        }
        return decoded
    }

    private static func writeConfig(_ config: AppConfig, to url: URL) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(config)
        let fm = FileManager.default
        let dir = url.deletingLastPathComponent()
        if !fm.fileExists(atPath: dir.path) {
            try fm.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        try data.write(to: url, options: .atomic)
    }

    private static func enforce0600Permissions(at url: URL) throws {
        try FileManager.default.setAttributes([.posixPermissions: 0o600], ofItemAtPath: url.path)
    }
}

enum SetupError: LocalizedError {
    case emptyToken

    var errorDescription: String? {
        switch self {
        case .emptyToken:
            return "User token is empty. Provide a valid Music-User-Token."
        }
    }
}

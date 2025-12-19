import Foundation

struct SetupHelper {
    private static let defaultConfigPath = "~/.mcp/AppleMusicMCPServer/configs/config.json"

    static func configURL(env: [String: String] = ProcessInfo.processInfo.environment, overridePath: String? = nil) -> URL {
        let override = overridePath ?? env["APPLE_MUSIC_CONFIG_PATH"] ?? defaultConfigPath
        let expanded = (override as NSString).expandingTildeInPath
        return URL(fileURLWithPath: expanded)
    }

    @discardableResult
    static func persistUserToken(
        _ token: String,
        configPath: String? = nil,
        env: [String: String] = ProcessInfo.processInfo.environment
    ) throws -> URL {
        let trimmed = token.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw SetupError.emptyToken }

        let url = configURL(env: env, overridePath: configPath)
        let existing = loadConfig(at: url)
        var updated = existing
        updated.userToken = trimmed

        try writeConfig(updated, to: url)
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
        let data = try JSONEncoder().encode(config)
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

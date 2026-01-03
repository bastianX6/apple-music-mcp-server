import Foundation

enum ServerError: LocalizedError {
    case notImplemented(String)
    case missingUserToken
    case missingDeveloperToken
    case invalidConfigPermissions
    case missingConfigFile(String)

    var errorDescription: String? {
        switch self {
        case .notImplemented(let feature):
            return "Not implemented: \(feature)"
        case .missingUserToken:
            return "User token is missing. Run the setup helper to acquire a Music-User-Token."
        case .missingDeveloperToken:
            return "Developer token credentials are missing. Set APPLE_MUSIC_TEAM_ID, APPLE_MUSIC_MUSICKIT_ID, and APPLE_MUSIC_PRIVATE_KEY."
        case .invalidConfigPermissions:
            return "Config file permissions must be 0600."
        case .missingConfigFile(let path):
            return "Config file not found at \(path). Run 'apple-music-mcp setup' or pass --config with a valid file."
        }
    }
}

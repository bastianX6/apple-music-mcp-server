import Foundation

enum ServerError: LocalizedError {
    case notImplemented(String)
    case missingUserToken
    case missingDeveloperToken
    case invalidConfigPermissions

    var errorDescription: String? {
        switch self {
        case .notImplemented(let feature):
            return "Not implemented: \(feature)"
        case .missingUserToken:
            return "User token is missing. Run the setup helper to acquire a Music-User-Token."
        case .missingDeveloperToken:
            return "Developer token credentials are missing. Set APPLE_MUSIC_TEAM_ID, APPLE_MUSIC_MUSICKIT_ID (or APPLE_MUSIC_MUSICKIT_KEY_ID), and private key."
        case .invalidConfigPermissions:
            return "Config file permissions must be 0600."
        }
    }
}

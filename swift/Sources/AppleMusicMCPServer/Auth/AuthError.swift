import Foundation

enum AuthError: LocalizedError {
    case missingCredentials
    case missingKey
    case invalidKey
    case signingFailed

    var errorDescription: String? {
        switch self {
        case .missingCredentials:
            return "Developer token credentials are missing. Configure team ID, key ID, and private key."
        case .missingKey:
            return "Developer private key is missing."
        case .invalidKey:
            return "Developer private key could not be parsed. Ensure it is a valid .p8 PEM."
        case .signingFailed:
            return "Failed to sign developer token."
        }
    }
}

import Foundation
import SwiftJWT

struct DeveloperTokenProvider {
    private let tokenLifetime: TimeInterval = 60 * 60 * 24 * 180 // 180 days (max allowed ~6 months)

    func token(using config: AppConfig) throws -> String {
        guard let teamID = config.teamID, let keyID = config.musicKitKeyID else {
            throw AuthError.missingCredentials
        }

        let privateKeyString = try loadPrivateKey(from: config)
        let privateKeyData = try decodePEM(privateKeyString)

        let now = Date()
        let claims = MusicKitClaims(iss: teamID, iat: now, exp: now.addingTimeInterval(tokenLifetime))

        var jwtHeader = Header()
        jwtHeader.kid = keyID
        jwtHeader.typ = "JWT"

        var jwt = JWT(header: jwtHeader, claims: claims)

        do {
            let jwtSigner = JWTSigner.es256(privateKey: privateKeyData)
            return try jwt.sign(using: jwtSigner)
        } catch {
            throw AuthError.signingFailed
        }
    }

    private func loadPrivateKey(from config: AppConfig) throws -> String {
        if let inline = config.privateKey, inline.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
            return inline
        }

        if let path = config.privateKeyPath {
            let expanded = (path as NSString).expandingTildeInPath
            return try String(contentsOfFile: expanded, encoding: .utf8)
        }

        throw AuthError.missingKey
    }

    private func decodePEM(_ pem: String) throws -> Data {
        let cleaned = pem
            .replacingOccurrences(of: "-----BEGIN PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "-----END PRIVATE KEY-----", with: "")
            .components(separatedBy: .newlines)
            .joined()
        guard let data = Data(base64Encoded: cleaned) else {
            throw AuthError.invalidKey
        }
        return data
    }

    private struct MusicKitClaims: Claims {
        let iss: String
        let iat: Date
        let exp: Date
    }
}

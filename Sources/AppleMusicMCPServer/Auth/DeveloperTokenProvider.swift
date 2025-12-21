import Foundation

#if canImport(CryptoKit)
import CryptoKit
#elseif canImport(Crypto)
import Crypto
#endif

struct DeveloperTokenProvider {
    private let tokenLifetime: TimeInterval = 60 * 60 * 24 * 180 // 180 days (max allowed ~6 months)

    func token(using config: AppConfig) throws -> String {
        guard let teamID = config.teamID?.trimmingCharacters(in: .whitespacesAndNewlines), teamID.isEmpty == false,
              let keyID = config.musicKitKeyID?.trimmingCharacters(in: .whitespacesAndNewlines), keyID.isEmpty == false else {
            throw AuthError.missingCredentials
        }

        let privateKeyString = try loadPrivateKey(from: config)

        let now = Date()
        let claims = MusicKitClaims(iss: teamID, iat: now, exp: now.addingTimeInterval(tokenLifetime))

        // Build JWT manually to avoid platform-specific key parsing issues.
        let header = JWTHeader(alg: "ES256", kid: keyID, typ: "JWT")

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970

        let headerData = try encoder.encode(header)
        let claimsData = try encoder.encode(claims)

        let signingInput = base64URLEncode(headerData) + "." + base64URLEncode(claimsData)

        do {
            let key = try P256.Signing.PrivateKey(pemRepresentation: privateKeyString)
            let signature = try key.signature(for: Data(signingInput.utf8)).rawRepresentation
            let token = signingInput + "." + base64URLEncode(signature)
            return token
        } catch {
            let message = "Developer token signing failed: \(error.localizedDescription)\n"
            FileHandle.standardError.write(Data(message.utf8))
            throw AuthError.signingFailed(reason: error.localizedDescription)
        }
    }

    private func loadPrivateKey(from config: AppConfig) throws -> String {
        if let inline = config.privateKey?.trimmingCharacters(in: .whitespacesAndNewlines), inline.isEmpty == false {
            return normalizePEM(inline)
        }

        if let path = config.privateKeyPath?.trimmingCharacters(in: .whitespacesAndNewlines), path.isEmpty == false {
            let expanded = (path as NSString).expandingTildeInPath
            let pem = try String(contentsOfFile: expanded, encoding: .utf8)
            return normalizePEM(pem)
        }

        throw AuthError.missingKey
    }

    private func decodePEM(_ pem: String) throws -> Data {
        let cleaned = pem
            .replacingOccurrences(of: "-----BEGIN PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "-----END PRIVATE KEY-----", with: "")
            .components(separatedBy: .whitespacesAndNewlines)
            .joined()
        guard let data = Data(base64Encoded: cleaned) else {
            throw AuthError.invalidKey
        }
        return data
    }

    private func normalizePEM(_ pem: String) -> String {
        // Accepts values with or without newlines and with literal "\n" sequences.
        let expanded = pem.replacingOccurrences(of: "\\n", with: "\n")
        let trimmed = expanded.trimmingCharacters(in: .whitespacesAndNewlines)

        // If header/footer are missing, wrap the raw body.
        let hasHeader = trimmed.contains("-----BEGIN PRIVATE KEY-----")
        let hasFooter = trimmed.contains("-----END PRIVATE KEY-----")

        let bodyOnly = trimmed
            .replacingOccurrences(of: "-----BEGIN PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "-----END PRIVATE KEY-----", with: "")
            .components(separatedBy: .whitespacesAndNewlines)
            .joined()

        // Wrap at 64 chars to satisfy strict PEM parsers.
        let normalizedBody = stride(from: 0, to: bodyOnly.count, by: 64).map { idx -> String in
            let start = bodyOnly.index(bodyOnly.startIndex, offsetBy: idx)
            let end = bodyOnly.index(start, offsetBy: 64, limitedBy: bodyOnly.endIndex) ?? bodyOnly.endIndex
            return String(bodyOnly[start..<end])
        }.joined(separator: "\n")
        let header = "-----BEGIN PRIVATE KEY-----"
        let footer = "-----END PRIVATE KEY-----"

        if hasHeader && hasFooter {
            return [header, normalizedBody, footer].joined(separator: "\n")
        } else {
            return [header, normalizedBody, footer].joined(separator: "\n")
        }
    }

    private struct MusicKitClaims: Codable {
        let iss: String
        let iat: Date
        let exp: Date
    }

    private struct JWTHeader: Codable {
        let alg: String
        let kid: String
        let typ: String
    }

    private func base64URLEncode(_ data: Data) -> String {
        let encoded = data.base64EncodedString()
        return encoded
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}

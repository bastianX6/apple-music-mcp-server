import Foundation

public struct AppleMusicAPIError: Decodable, Sendable {
    public let status: String?
    public let code: String?
    public let title: String?
    public let detail: String?

    public var summary: String {
        [title, detail].compactMap { $0 }.joined(separator: " - ")
    }

    public static func from(data: Data) -> AppleMusicAPIError? {
        guard let decoded = try? JSONDecoder().decode(AppleMusicErrorEnvelope.self, from: data).errors.first else {
            return nil
        }
        return decoded
    }

    private struct AppleMusicErrorEnvelope: Decodable {
        let errors: [AppleMusicAPIError]
    }
}

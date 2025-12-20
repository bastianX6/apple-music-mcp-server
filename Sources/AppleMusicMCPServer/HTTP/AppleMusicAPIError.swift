import Foundation

struct AppleMusicAPIError: Decodable, Sendable {
    let status: String?
    let code: String?
    let title: String?
    let detail: String?

    var summary: String {
        [title, detail].compactMap { $0 }.joined(separator: " - ")
    }

    static func from(data: Data) -> AppleMusicAPIError? {
        guard let decoded = try? JSONDecoder().decode(AppleMusicErrorEnvelope.self, from: data).errors.first else {
            return nil
        }
        return decoded
    }

    private struct AppleMusicErrorEnvelope: Decodable {
        let errors: [AppleMusicAPIError]
    }
}

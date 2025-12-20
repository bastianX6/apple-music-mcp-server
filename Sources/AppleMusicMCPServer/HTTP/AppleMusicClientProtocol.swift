import Foundation

protocol AppleMusicClientProtocol: Sendable {
    var userToken: String? { get }
    func get(path: String, queryItems: [URLQueryItem]) async throws -> Data
    func post(path: String, body: Data?) async throws -> Data
}

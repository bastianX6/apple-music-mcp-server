import Foundation

protocol AppleMusicClientProtocol: Sendable {
    var userToken: String? { get }
    func get(path: String, queryItems: [URLQueryItem]) async throws -> Data
    func post(path: String, queryItems: [URLQueryItem], body: Data?) async throws -> Data
    func put(path: String, queryItems: [URLQueryItem], body: Data?) async throws -> Data
    func delete(path: String, queryItems: [URLQueryItem]) async throws -> Data
}

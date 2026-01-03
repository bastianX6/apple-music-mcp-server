import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct AppleMusicClient: AppleMusicClientProtocol {
    let developerToken: String
    let userToken: String?
    let baseURL = URL(string: "https://api.music.apple.com")!

    enum HTTPError: LocalizedError {
        case invalidResponse
        case badStatus(code: Int, payload: Data, apiError: AppleMusicAPIError?)

        var errorDescription: String? {
            switch self {
            case .invalidResponse:
                return "Invalid response from Apple Music API."
            case .badStatus(let code, _, let apiError):
                if let apiError {
                    return "Apple Music API returned status \(code): \(apiError.summary)"
                }
                return "Apple Music API returned status \(code)."
            }
        }
    }

    func get(path: String, queryItems: [URLQueryItem] = []) async throws -> Data {
        try await request(method: "GET", path: path, queryItems: queryItems, body: nil)
    }

    func post(path: String, queryItems: [URLQueryItem] = [], body: Data?) async throws -> Data {
        try await request(method: "POST", path: path, queryItems: queryItems, body: body)
    }

    func put(path: String, queryItems: [URLQueryItem] = [], body: Data?) async throws -> Data {
        try await request(method: "PUT", path: path, queryItems: queryItems, body: body)
    }

    func delete(path: String, queryItems: [URLQueryItem] = []) async throws -> Data {
        try await request(method: "DELETE", path: path, queryItems: queryItems, body: nil)
    }

    private func request(method: String, path: String, queryItems: [URLQueryItem], body: Data?) async throws -> Data {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }
        guard let url = components?.url else { throw HTTPError.invalidResponse }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if body != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        request.setValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
        if let userToken {
            request.setValue(userToken, forHTTPHeaderField: "Music-User-Token")
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HTTPError.invalidResponse
        }

        if 200..<300 ~= httpResponse.statusCode {
            return data
        }

        let apiError = AppleMusicAPIError.from(data: data)
        throw HTTPError.badStatus(code: httpResponse.statusCode, payload: data, apiError: apiError)
    }
}

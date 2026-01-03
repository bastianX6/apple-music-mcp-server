import Foundation
import MCP

struct ToolRegistry: Sendable {
    let client: AppleMusicClientProtocol
    let storefrontResolver: StorefrontResolver
    private let storefrontToolNames: Set<String> = [
        "search_catalog",
        "get_search_hints",
        "get_search_suggestions",
        "get_charts",
        "get_genres",
        "get_stations",
        "get_catalog_songs",
        "get_catalog_albums",
        "get_catalog_artists",
        "get_catalog_playlists",
        "get_music_videos",
        "get_curators",
        "get_activities",
        "get_catalog_resources",
        "get_catalog_resource",
        "get_catalog_relationship",
        "get_catalog_view",
        "get_catalog_multi_by_type_ids",
        "get_best_language_tag"
    ]

    init(client: AppleMusicClientProtocol, storefrontResolver: StorefrontResolver = StorefrontResolver()) {
        self.client = client
        self.storefrontResolver = storefrontResolver
    }

    func handleGenericGet(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let rawPath = params.arguments?["path"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'path'.")], isError: true)
        }

        let trimmed = rawPath.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let path: String
        let queryItemsFromPath: [URLQueryItem]

        if let questionMarkIndex = trimmed.firstIndex(of: "?") {
            path = String(trimmed[..<questionMarkIndex])
            let queryString = String(trimmed[trimmed.index(after: questionMarkIndex)...])
            queryItemsFromPath = URLComponents(string: "https://placeholder?\(queryString)")?.queryItems ?? []
        } else {
            path = trimmed
            queryItemsFromPath = []
        }

        do {
            let data = try await client.get(path: path, queryItems: queryItemsFromPath)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetUserStorefront() async throws -> CallTool.Result {
        guard client.userToken != nil else {
            return CallTool.Result(
                content: [.text("User token is missing. Run the setup helper to acquire a Music-User-Token.")],
                isError: true
            )
        }

        do {
            let (_, data) = try await storefrontResolver.fetchStorefront(client: client)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    // Visible for tests in the same module.
    func prettyPrintedJSON(_ data: Data) -> String? {
        guard let object = try? JSONSerialization.jsonObject(with: data),
              JSONSerialization.isValidJSONObject(object) else {
            return nil
        }
        let formatted = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted])
        return formatted.flatMap { String(data: $0, encoding: .utf8) }
    }
}

extension ToolRegistry {
    func prefetchStorefrontIfNeeded(toolName: String) async -> CallTool.Result? {
        guard client.userToken != nil else { return nil }
        guard storefrontToolNames.contains(toolName) else { return nil }
        do {
            _ = try await storefrontResolver.resolve(client: client)
            return nil
        } catch {
            let message = "Failed to resolve user storefront: \(error.localizedDescription)"
            return CallTool.Result(content: [.text(message)], isError: true)
        }
    }

    func resolveStorefront(_ requested: String?) async -> StorefrontResolution {
        if client.userToken == nil {
            let fallback = requested?.trimmingCharacters(in: .whitespacesAndNewlines)
            return .success((fallback?.isEmpty ?? true) ? "us" : (fallback ?? "us"))
        }

        do {
            let storefront = try await storefrontResolver.resolve(client: client)
            return .success(storefront)
        } catch {
            let message = "Failed to resolve user storefront: \(error.localizedDescription)"
            return .failure(CallTool.Result(content: [.text(message)], isError: true))
        }
    }
}

enum StorefrontResolution {
    case success(String)
    case failure(CallTool.Result)

    var errorResult: CallTool.Result {
        switch self {
        case .success:
            return CallTool.Result(content: [.text("Unexpected storefront resolution state.")], isError: true)
        case .failure(let result):
            return result
        }
    }
}

extension ToolRegistry {
    func requireUserToken() -> CallTool.Result? {
        guard client.userToken != nil else {
            return CallTool.Result(
                content: [.text("User token is missing. Run the setup helper to acquire a Music-User-Token.")],
                isError: true
            )
        }
        return nil
    }

    func stringList(from value: Value) -> [String] {
        if let stringValue = value.stringValue {
            return stringValue
                .split(separator: ",")
                .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
        }
        if let intValue = value.intValue {
            return [String(intValue)]
        }
        if let doubleValue = value.doubleValue {
            return [String(doubleValue)]
        }
        if let boolValue = value.boolValue {
            return [boolValue ? "true" : "false"]
        }
        if let arrayValue = value.arrayValue {
            return arrayValue.flatMap { stringList(from: $0) }
        }
        return []
    }

    func queryItem(named name: String, from value: Value) -> URLQueryItem? {
        let values = stringList(from: value)
        guard !values.isEmpty else { return nil }
        return URLQueryItem(name: name, value: values.joined(separator: ","))
    }

    func optionalQueryItems(from params: CallTool.Parameters, allowed keys: [String]) -> [URLQueryItem] {
        guard let arguments = params.arguments else { return [] }
        return keys.compactMap { key in
            guard let value = arguments[key] else { return nil }
            return queryItem(named: key, from: value)
        }
    }

    func idsQueryItems(from value: Value, prefix: String = "ids") -> [URLQueryItem] {
        guard let object = value.objectValue else { return [] }
        return object.sorted { $0.key < $1.key }.compactMap { key, itemValue in
            guard let queryItem = queryItem(named: "\(prefix)[\(key)]", from: itemValue) else { return nil }
            return queryItem
        }
    }
}

actor StorefrontResolver {
    enum Error: Swift.Error, LocalizedError {
        case missingStorefront

        var errorDescription: String? {
            switch self {
            case .missingStorefront:
                return "User storefront could not be determined from response."
            }
        }
    }

    private var cached: String?

    func resolve(client: AppleMusicClientProtocol) async throws -> String {
        if let cached {
            return cached
        }

        let (storefront, _) = try await fetchStorefront(client: client)
        return storefront
    }

    func fetchStorefront(client: AppleMusicClientProtocol) async throws -> (String, Data) {
        let data = try await client.get(path: "v1/me/storefront", queryItems: [])
        let id = try parseStorefrontId(from: data)
        cached = id
        return (id, data)
    }

    private func parseStorefrontId(from data: Data) throws -> String {
        let decoded = try JSONDecoder().decode(StorefrontEnvelope.self, from: data)
        guard let id = decoded.data.first?.id else {
            throw Error.missingStorefront
        }
        return id
    }

    private struct StorefrontEnvelope: Decodable {
        let data: [Storefront]
    }

    private struct Storefront: Decodable {
        let id: String
    }
}

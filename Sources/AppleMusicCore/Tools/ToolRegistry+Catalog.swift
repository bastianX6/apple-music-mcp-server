import Foundation
import MCP

extension ToolRegistry {
    func handleSearchCatalog(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let term = params.arguments?["term"]?.stringValue?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return CallTool.Result(content: [.text("Missing required argument 'term'.")], isError: true)
        }
        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
        let types = params.arguments?["types"]?.stringValue ?? "songs,albums,artists,playlists"
        let limit = params.arguments?["limit"]?.intValue ?? 10
        let offset = params.arguments?["offset"]?.intValue ?? 0
        let cappedLimit = max(1, min(limit, 25))
        let cappedOffset = max(0, offset)

        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "types", value: types),
            URLQueryItem(name: "limit", value: String(cappedLimit))
        ]
        if cappedOffset > 0 {
            queryItems.append(URLQueryItem(name: "offset", value: String(cappedOffset)))
        }
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["with", "l"]))

        do {
            let data = try await client.get(path: "v1/catalog/\(storefront)/search", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetCatalogSongs(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let idsValue = params.arguments?["ids"] else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }
        let ids = stringList(from: idsValue).joined(separator: ",")
        guard !ids.isEmpty else {
            return CallTool.Result(content: [.text("No IDs provided after parsing.")], isError: true)
        }

        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }

        var queryItems: [URLQueryItem] = [URLQueryItem(name: "ids", value: ids)]
        if let limit = params.arguments?["limit"]?.intValue {
            let cappedLimit = max(1, min(limit, 25))
            queryItems.append(URLQueryItem(name: "limit", value: String(cappedLimit)))
        }
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["include", "extend", "l"]))

        do {
            let data = try await client.get(path: "v1/catalog/\(storefront)/songs", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetCatalogAlbums(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let idsValue = params.arguments?["ids"] else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }
        let ids = stringList(from: idsValue).joined(separator: ",")
        guard !ids.isEmpty else {
            return CallTool.Result(content: [.text("No IDs provided after parsing.")], isError: true)
        }

        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }

        var queryItems: [URLQueryItem] = [URLQueryItem(name: "ids", value: ids)]
        if let limit = params.arguments?["limit"]?.intValue {
            let cappedLimit = max(1, min(limit, 25))
            queryItems.append(URLQueryItem(name: "limit", value: String(cappedLimit)))
        }
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["include", "extend", "l"]))

        do {
            let data = try await client.get(path: "v1/catalog/\(storefront)/albums", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetCatalogArtists(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let idsValue = params.arguments?["ids"] else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }
        let ids = stringList(from: idsValue).joined(separator: ",")
        guard !ids.isEmpty else {
            return CallTool.Result(content: [.text("No IDs provided after parsing.")], isError: true)
        }

        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
        var queryItems: [URLQueryItem] = [URLQueryItem(name: "ids", value: ids)]
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["include", "extend", "l"]))

        do {
            let data = try await client.get(path: "v1/catalog/\(storefront)/artists", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetCatalogPlaylists(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let idsValue = params.arguments?["ids"] else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }
        let ids = stringList(from: idsValue).joined(separator: ",")
        guard !ids.isEmpty else {
            return CallTool.Result(content: [.text("No IDs provided after parsing.")], isError: true)
        }

        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
        var queryItems: [URLQueryItem] = [URLQueryItem(name: "ids", value: ids)]
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["include", "extend", "l"]))

        do {
            let data = try await client.get(path: "v1/catalog/\(storefront)/playlists", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetCurators(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let idsValue = params.arguments?["ids"] else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }
        let ids = stringList(from: idsValue).joined(separator: ",")
        guard !ids.isEmpty else {
            return CallTool.Result(content: [.text("No IDs provided after parsing.")], isError: true)
        }

        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
        var queryItems: [URLQueryItem] = [URLQueryItem(name: "ids", value: ids)]
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["include", "extend", "l"]))

        do {
            let data = try await client.get(path: "v1/catalog/\(storefront)/curators", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetActivities(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let idsValue = params.arguments?["ids"] else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }
        let ids = stringList(from: idsValue).joined(separator: ",")
        guard !ids.isEmpty else {
            return CallTool.Result(content: [.text("No IDs provided after parsing.")], isError: true)
        }

        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
        var queryItems: [URLQueryItem] = [URLQueryItem(name: "ids", value: ids)]
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["include", "extend", "l"]))

        do {
            let data = try await client.get(path: "v1/catalog/\(storefront)/activities", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetCatalogResources(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let type = params.arguments?["type"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'type'.")], isError: true)
        }
        guard let idsValue = params.arguments?["ids"] else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }
        let ids = stringList(from: idsValue).joined(separator: ",")
        guard !ids.isEmpty else {
            return CallTool.Result(content: [.text("No IDs provided after parsing.")], isError: true)
        }

        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
        let path = "v1/catalog/\(storefront)/\(type)"
        var queryItems: [URLQueryItem] = [URLQueryItem(name: "ids", value: ids)]
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["include", "extend", "l"]))

        do {
            let data = try await client.get(path: path, queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetMusicVideos(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let idsValue = params.arguments?["ids"] else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }
        let ids = stringList(from: idsValue).joined(separator: ",")
        guard !ids.isEmpty else {
            return CallTool.Result(content: [.text("No IDs provided after parsing.")], isError: true)
        }

        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
        var queryItems: [URLQueryItem] = [URLQueryItem(name: "ids", value: ids)]
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["include", "extend", "l"]))

        do {
            let data = try await client.get(path: "v1/catalog/\(storefront)/music-videos", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetGenres(params: CallTool.Parameters) async throws -> CallTool.Result {
        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
        let queryItems = optionalQueryItems(from: params, allowed: ["l"])

        do {
            let data = try await client.get(path: "v1/catalog/\(storefront)/genres", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetCharts(params: CallTool.Parameters) async throws -> CallTool.Result {
        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
        let types = params.arguments?["types"]?.stringValue ?? "songs,albums,playlists"
        let chart = params.arguments?["chart"]?.stringValue ?? "most-played"
        let limit = params.arguments?["limit"]?.intValue ?? 10
        let offset = params.arguments?["offset"]?.intValue ?? 0
        let cappedLimit = max(1, min(limit, 50))
        let cappedOffset = max(0, offset)

        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "types", value: types),
            URLQueryItem(name: "chart", value: chart),
            URLQueryItem(name: "limit", value: String(cappedLimit))
        ]
        if cappedOffset > 0 {
            queryItems.append(URLQueryItem(name: "offset", value: String(cappedOffset)))
        }
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["genre", "with", "l"]))

        do {
            let data = try await client.get(path: "v1/catalog/\(storefront)/charts", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetStations(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let idsValue = params.arguments?["ids"] else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }
        let ids = stringList(from: idsValue).joined(separator: ",")
        guard !ids.isEmpty else {
            return CallTool.Result(content: [.text("No IDs provided after parsing.")], isError: true)
        }

        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
        var queryItems: [URLQueryItem] = [URLQueryItem(name: "ids", value: ids)]
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["include", "extend", "l"]))

        do {
            let data = try await client.get(path: "v1/catalog/\(storefront)/stations", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetSearchSuggestions(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let term = params.arguments?["term"]?.stringValue?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return CallTool.Result(content: [.text("Missing required argument 'term'.")], isError: true)
        }
        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
        let kinds = params.arguments?["kinds"]?.stringValue ?? "terms"
        let limit = params.arguments?["limit"]?.intValue

        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "kinds", value: kinds)
        ]
        if let limit {
            let cappedLimit = max(1, min(limit, 25))
            queryItems.append(URLQueryItem(name: "limit", value: String(cappedLimit)))
        }
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["types", "l"]))

        do {
            let data = try await client.get(path: "v1/catalog/\(storefront)/search/suggestions", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetSearchHints(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let term = params.arguments?["term"]?.stringValue?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return CallTool.Result(content: [.text("Missing required argument 'term'.")], isError: true)
        }
        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
        let limit = params.arguments?["limit"]?.intValue

        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "term", value: term)
        ]
        if let limit {
            let cappedLimit = max(1, min(limit, 25))
            queryItems.append(URLQueryItem(name: "limit", value: String(cappedLimit)))
        }
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["l"]))

        do {
            let data = try await client.get(path: "v1/catalog/\(storefront)/search/hints", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetCatalogResource(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let type = params.arguments?["type"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'type'.")], isError: true)
        }
        guard let id = params.arguments?["id"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'id'.")], isError: true)
        }

        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
        let path = "v1/catalog/\(storefront)/\(type)/\(id)"
        let queryItems = optionalQueryItems(from: params, allowed: ["include", "extend", "l"])

        do {
            let data = try await client.get(path: path, queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetCatalogRelationship(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let type = params.arguments?["type"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'type'.")], isError: true)
        }
        guard let id = params.arguments?["id"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'id'.")], isError: true)
        }
        guard let relationship = params.arguments?["relationship"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'relationship'.")], isError: true)
        }

        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
        let path = "v1/catalog/\(storefront)/\(type)/\(id)/\(relationship)"
        let queryItems = optionalQueryItems(from: params, allowed: ["include", "extend", "l", "limit", "offset"])

        do {
            let data = try await client.get(path: path, queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetCatalogView(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let type = params.arguments?["type"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'type'.")], isError: true)
        }
        guard let id = params.arguments?["id"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'id'.")], isError: true)
        }
        guard let view = params.arguments?["view"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'view'.")], isError: true)
        }

        guard let allowedViews = catalogViewsByType[type] else {
            let supported = catalogViewsByType.keys.sorted().joined(separator: ", ")
            return CallTool.Result(
                content: [.text("Type '\(type)' does not support views. Supported types: \(supported).")],
                isError: true
            )
        }
        guard allowedViews.contains(view) else {
            let allowed = allowedViews.sorted().joined(separator: ", ")
            return CallTool.Result(
                content: [.text("Invalid view '\(view)' for type '\(type)'. Allowed views: \(allowed).")],
                isError: true
            )
        }

        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
        let path = "v1/catalog/\(storefront)/\(type)/\(id)/view/\(view)"
        let queryItems = optionalQueryItems(from: params, allowed: ["include", "extend", "l", "limit", "offset"])

        do {
            let data = try await client.get(path: path, queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetCatalogMultiByTypeIds(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let idsValue = params.arguments?["ids"] else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }

        let idsItems = idsQueryItems(from: idsValue, prefix: "ids")
        guard !idsItems.isEmpty else {
            return CallTool.Result(content: [.text("Argument 'ids' must be an object of resource types to IDs.")], isError: true)
        }

        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
        let path = "v1/catalog/\(storefront)"
        let queryItems = idsItems + optionalQueryItems(from: params, allowed: ["include", "extend", "l"])

        do {
            let data = try await client.get(path: path, queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetBestLanguageTag(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let acceptLanguage = params.arguments?["acceptLanguage"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'acceptLanguage'.")], isError: true)
        }

        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "acceptLanguage", value: acceptLanguage)
        ]
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["l"]))

        do {
            let data = try await client.get(path: "v1/language/\(storefront)/tag", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

}

private let catalogViewsByType: [String: Set<String>] = [
    "albums": ["appears-on", "other-versions", "related-albums", "related-videos"],
    "artists": [
        "appears-on-albums",
        "compilation-albums",
        "featured-albums",
        "featured-music-videos",
        "featured-playlists",
        "full-albums",
        "latest-release",
        "live-albums",
        "similar-artists",
        "singles",
        "top-music-videos",
        "top-songs"
    ],
    "music-videos": ["more-by-artist", "more-in-genre"],
    "playlists": ["featured-artists", "more-by-curator"],
    "record-labels": ["latest-releases", "top-releases"]
]

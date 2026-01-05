import Foundation
import MCP

extension ToolRegistry {
    func handleGetLibraryPlaylists(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }

        let limit = params.arguments?["limit"]?.intValue ?? 25
        let offset = params.arguments?["offset"]?.intValue ?? 0
        let cappedLimit = max(1, min(limit, 100))
        let cappedOffset = max(0, offset)

        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: String(cappedLimit)),
            URLQueryItem(name: "offset", value: String(cappedOffset))
        ]
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["include", "extend", "l"]))

        do {
            let data = try await client.get(path: "v1/me/library/playlists", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetLibrarySongs(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }

        let limit = params.arguments?["limit"]?.intValue ?? 25
        let offset = params.arguments?["offset"]?.intValue ?? 0
        let cappedLimit = max(1, min(limit, 100))
        let cappedOffset = max(0, offset)

        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: String(cappedLimit)),
            URLQueryItem(name: "offset", value: String(cappedOffset))
        ]
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["include", "extend", "l"]))

        do {
            let data = try await client.get(path: "v1/me/library/songs", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetLibraryAlbums(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }

        let limit = params.arguments?["limit"]?.intValue ?? 25
        let offset = params.arguments?["offset"]?.intValue ?? 0
        let cappedLimit = max(1, min(limit, 100))
        let cappedOffset = max(0, offset)

        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: String(cappedLimit)),
            URLQueryItem(name: "offset", value: String(cappedOffset))
        ]
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["include", "extend", "l"]))

        do {
            let data = try await client.get(path: "v1/me/library/albums", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetLibraryArtists(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }

        let limit = params.arguments?["limit"]?.intValue ?? 25
        let offset = params.arguments?["offset"]?.intValue ?? 0
        let cappedLimit = max(1, min(limit, 100))
        let cappedOffset = max(0, offset)

        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: String(cappedLimit)),
            URLQueryItem(name: "offset", value: String(cappedOffset))
        ]
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["include", "extend", "l"]))

        do {
            let data = try await client.get(path: "v1/me/library/artists", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetLibraryResources(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }
        guard let type = params.arguments?["type"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'type'.")], isError: true)
        }

        let path = "v1/me/library/\(type)"
        var queryItems = optionalQueryItems(from: params, allowed: ["include", "extend", "l", "limit", "offset", "filter[identity]"])
        if let idsValue = params.arguments?["ids"] {
            let ids = stringList(from: idsValue).joined(separator: ",")
            guard !ids.isEmpty else {
                return CallTool.Result(content: [.text("No IDs provided after parsing.")], isError: true)
            }
            queryItems.append(URLQueryItem(name: "ids", value: ids))
        }

        do {
            let data = try await client.get(path: path, queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetLibraryResource(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }
        guard let type = params.arguments?["type"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'type'.")], isError: true)
        }
        guard let id = params.arguments?["id"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'id'.")], isError: true)
        }

        let path = "v1/me/library/\(type)/\(id)"
        let queryItems = optionalQueryItems(from: params, allowed: ["include", "extend", "l"])

        do {
            let data = try await client.get(path: path, queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetLibraryRelationship(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }
        guard let type = params.arguments?["type"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'type'.")], isError: true)
        }
        guard let id = params.arguments?["id"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'id'.")], isError: true)
        }
        guard let relationship = params.arguments?["relationship"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'relationship'.")], isError: true)
        }

        let path = "v1/me/library/\(type)/\(id)/\(relationship)"
        let queryItems = optionalQueryItems(from: params, allowed: ["include", "extend", "l", "limit", "offset"])

        do {
            let data = try await client.get(path: path, queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetLibraryMultiByTypeIds(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }
        guard let idsValue = params.arguments?["ids"], let idsObject = idsValue.objectValue else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }

        var idsItems: [URLQueryItem] = []
        var invalidKeys: [String] = []
        for (key, value) in idsObject.sorted(by: { $0.key < $1.key }) {
            guard let normalizedKey = normalizeLibraryTypeKey(key) else {
                invalidKeys.append(key)
                continue
            }
            if let queryItem = queryItem(named: "ids[\(normalizedKey)]", from: value) {
                idsItems.append(queryItem)
            }
        }

        if !invalidKeys.isEmpty {
            let allowed = libraryTypeKeys.sorted().joined(separator: ", ")
            return CallTool.Result(
                content: [.text("Invalid ids keys: \(invalidKeys.joined(separator: ", ")). Allowed: \(allowed).")],
                isError: true
            )
        }

        guard !idsItems.isEmpty else {
            return CallTool.Result(content: [.text("Argument 'ids' must be an object of resource types to IDs.")], isError: true)
        }

        let queryItems = idsItems + optionalQueryItems(from: params, allowed: ["include", "extend", "l"])

        do {
            let data = try await client.get(path: "v1/me/library", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleLibrarySearch(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }
        guard let term = params.arguments?["term"]?.stringValue?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return CallTool.Result(content: [.text("Missing required argument 'term'.")], isError: true)
        }
        guard let typesValue = params.arguments?["types"] else {
            return CallTool.Result(content: [.text("Missing required argument 'types'.")], isError: true)
        }

        let rawTypes = stringList(from: typesValue)
        guard !rawTypes.isEmpty else {
            return CallTool.Result(content: [.text("No types provided after parsing.")], isError: true)
        }
        let normalization = normalizeLibraryTypes(rawTypes)
        if !normalization.invalid.isEmpty {
            let allowed = libraryTypeKeys.sorted().joined(separator: ", ")
            return CallTool.Result(
                content: [.text("Invalid types: \(normalization.invalid.joined(separator: ", ")). Allowed: \(allowed).")],
                isError: true
            )
        }
        let types = normalization.valid.joined(separator: ",")

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
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["l"]))

        do {
            let data = try await client.get(path: "v1/me/library/search", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetLibraryRecentlyAdded(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }

        let limit = params.arguments?["limit"]?.intValue ?? 25
        let offset = params.arguments?["offset"]?.intValue ?? 0
        let cappedLimit = max(1, min(limit, 100))
        let cappedOffset = max(0, offset)

        var queryItems: [URLQueryItem] = [URLQueryItem(name: "limit", value: String(cappedLimit))]
        if cappedOffset > 0 {
            queryItems.append(URLQueryItem(name: "offset", value: String(cappedOffset)))
        }
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["l"]))
        do {
            let data = try await client.get(path: "v1/me/library/recently-added", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetRecentlyPlayed(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }

        let limit = params.arguments?["limit"]?.intValue ?? 10
        let offset = params.arguments?["offset"]?.intValue ?? 0
        let cappedLimit = max(1, min(limit, 100))
        let cappedOffset = max(0, offset)

        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: String(cappedLimit))
        ]
        if cappedOffset > 0 {
            queryItems.append(URLQueryItem(name: "offset", value: String(cappedOffset)))
        }
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["types", "include", "extend", "l"]))

        do {
            let data = try await client.get(path: "v1/me/recent/played", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetRecentlyPlayedTracks(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }

        let limit = params.arguments?["limit"]?.intValue ?? 10
        let offset = params.arguments?["offset"]?.intValue ?? 0
        let cappedLimit = max(1, min(limit, 100))
        let cappedOffset = max(0, offset)

        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: String(cappedLimit))
        ]
        if cappedOffset > 0 {
            queryItems.append(URLQueryItem(name: "offset", value: String(cappedOffset)))
        }
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["types", "include", "extend", "l"]))

        do {
            let data = try await client.get(path: "v1/me/recent/played/tracks", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetRecentlyPlayedStations(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }

        let limit = params.arguments?["limit"]?.intValue ?? 10
        let offset = params.arguments?["offset"]?.intValue ?? 0
        let cappedLimit = max(1, min(limit, 100))
        let cappedOffset = max(0, offset)

        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: String(cappedLimit))
        ]
        if cappedOffset > 0 {
            queryItems.append(URLQueryItem(name: "offset", value: String(cappedOffset)))
        }
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["include", "extend", "l"]))

        do {
            let data = try await client.get(path: "v1/me/recent/radio-stations", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetRecommendations(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }

        let limit = params.arguments?["limit"]?.intValue ?? 10
        let cappedLimit = max(1, min(limit, 50))

        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: String(cappedLimit))
        ]
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["ids", "include", "extend", "l"]))

        do {
            let data = try await client.get(path: "v1/me/recommendations", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetRecommendation(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }
        guard let id = params.arguments?["id"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'id'.")], isError: true)
        }

        let queryItems = optionalQueryItems(from: params, allowed: ["include", "extend", "l"])
        do {
            let data = try await client.get(path: "v1/me/recommendations/\(id)", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetRecommendationRelationship(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }
        guard let id = params.arguments?["id"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'id'.")], isError: true)
        }
        guard let relationship = params.arguments?["relationship"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'relationship'.")], isError: true)
        }

        guard allowedRecommendationRelationships.contains(relationship) else {
            let allowed = allowedRecommendationRelationships.sorted().joined(separator: ", ")
            return CallTool.Result(
                content: [.text("Invalid relationship '\(relationship)'. Allowed relationships: \(allowed).")],
                isError: true
            )
        }

        let queryItems = optionalQueryItems(from: params, allowed: ["include", "extend", "l", "limit", "offset"])
        do {
            let data = try await client.get(path: "v1/me/recommendations/\(id)/\(relationship)", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetHeavyRotation(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }

        let limit = params.arguments?["limit"]?.intValue ?? 10
        let offset = params.arguments?["offset"]?.intValue ?? 0
        let cappedLimit = max(1, min(limit, 100))
        let cappedOffset = max(0, offset)

        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: String(cappedLimit))
        ]
        if cappedOffset > 0 {
            queryItems.append(URLQueryItem(name: "offset", value: String(cappedOffset)))
        }
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["include", "extend", "l"]))

        do {
            let data = try await client.get(path: "v1/me/history/heavy-rotation", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetReplayData(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }
        let arguments = params.arguments ?? [:]
        switch buildReplayQueryItems(arguments: arguments) {
        case .failure(let errorResult):
            return errorResult
        case .success(let queryItems):
            do {
                let data = try await client.get(path: "v1/me/music-summaries", queryItems: queryItems)
                let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
                return CallTool.Result(content: [.text(text)], isError: false)
            } catch {
                return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
            }
        }
    }

    func handleGetReplay(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }
        var arguments = params.arguments ?? [:]
        let year = arguments["year"]?.stringValue ?? arguments["filter[year]"]?.stringValue ?? "latest"
        arguments["filter[year]"] = .string(year)

        switch buildReplayQueryItems(arguments: arguments) {
        case .failure(let errorResult):
            return errorResult
        case .success(let queryItems):
            do {
                let data = try await client.get(path: "v1/me/music-summaries", queryItems: queryItems)
                let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
                return CallTool.Result(content: [.text(text)], isError: false)
            } catch {
                return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
            }
        }
    }

    func handleCreatePlaylist(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }
        guard let name = params.arguments?["name"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'name'.")], isError: true)
        }
        let description = params.arguments?["description"]?.stringValue
        let parentId = params.arguments?["parent"]?.stringValue

        let trackValues = params.arguments?["tracks"] ?? params.arguments?["trackIds"]
        let trackIds = trackValues.map { stringList(from: $0) } ?? []

        let bodyDict: [String: Any] = {
            var attributes: [String: Any] = ["name": name]
            if let description { attributes["description"] = description }
            var payload: [String: Any] = ["attributes": attributes]
            var relationships: [String: Any] = [:]
            if let parentId, !parentId.isEmpty {
                relationships["parent"] = [
                    "data": ["id": parentId, "type": "library-playlist-folders"]
                ]
            }
            if !trackIds.isEmpty {
                let dataArray = trackIds.map { ["id": $0, "type": "songs"] }
                relationships["tracks"] = ["data": dataArray]
            }
            if !relationships.isEmpty {
                payload["relationships"] = relationships
            }
            return payload
        }()

        guard let body = try? JSONSerialization.data(withJSONObject: bodyDict, options: []) else {
            return CallTool.Result(content: [.text("Failed to encode request body.")], isError: true)
        }

        do {
            let data = try await client.post(path: "v1/me/library/playlists", queryItems: [], body: body)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleAddPlaylistTracks(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }
        guard let playlistId = params.arguments?["playlistId"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'playlistId'.")], isError: true)
        }
        guard let trackIdsValue = params.arguments?["trackIds"] else {
            return CallTool.Result(content: [.text("Missing required argument 'trackIds'.")], isError: true)
        }

        let ids = stringList(from: trackIdsValue)
        guard !ids.isEmpty else {
            return CallTool.Result(content: [.text("No track IDs provided after parsing.")], isError: true)
        }

        let dataArray = ids.map { ["id": $0, "type": "songs"] }
        let bodyDict: [String: Any] = ["data": dataArray]

        guard let body = try? JSONSerialization.data(withJSONObject: bodyDict, options: []) else {
            return CallTool.Result(content: [.text("Failed to encode request body.")], isError: true)
        }

        let path = "v1/me/library/playlists/\(playlistId)/tracks"

        do {
            let data = try await client.post(path: path, queryItems: [], body: body)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleCreatePlaylistFolder(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }
        guard let name = params.arguments?["name"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'name'.")], isError: true)
        }

        let bodyDict: [String: Any] = [
            "attributes": ["name": name]
        ]
        guard let body = try? JSONSerialization.data(withJSONObject: bodyDict, options: []) else {
            return CallTool.Result(content: [.text("Failed to encode request body.")], isError: true)
        }

        do {
            let data = try await client.post(path: "v1/me/library/playlist-folders", queryItems: [], body: body)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleAddLibraryResources(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }
        guard let idsValue = params.arguments?["ids"] else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }

        var queryItems = idsQueryItems(from: idsValue, prefix: "ids")
        if queryItems.isEmpty, let resourceType = params.arguments?["resourceType"]?.stringValue {
            let ids = stringList(from: idsValue).joined(separator: ",")
            if !ids.isEmpty {
                queryItems = [URLQueryItem(name: "ids[\(resourceType)]", value: ids)]
            }
        }
        guard !queryItems.isEmpty else {
            return CallTool.Result(content: [.text("Argument 'ids' must be an object of resource types to IDs.")], isError: true)
        }

        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["l"]))

        do {
            let data = try await client.post(path: "v1/me/library", queryItems: queryItems, body: nil)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleSetRating(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }
        guard let resourceType = params.arguments?["resourceType"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'resourceType'.")], isError: true)
        }
        guard let id = params.arguments?["id"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'id'.")], isError: true)
        }
        guard let value = params.arguments?["value"]?.intValue else {
            return CallTool.Result(content: [.text("Missing required argument 'value'.")], isError: true)
        }

        let bodyDict: [String: Any] = [
            "type": "ratings",
            "attributes": ["value": value]
        ]
        guard let body = try? JSONSerialization.data(withJSONObject: bodyDict, options: []) else {
            return CallTool.Result(content: [.text("Failed to encode request body.")], isError: true)
        }

        let queryItems = optionalQueryItems(from: params, allowed: ["l"])
        let path = "v1/me/ratings/\(resourceType)/\(id)"

        do {
            let data = try await client.put(path: path, queryItems: queryItems, body: body)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleDeleteRating(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }
        guard let resourceType = params.arguments?["resourceType"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'resourceType'.")], isError: true)
        }
        guard let id = params.arguments?["id"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'id'.")], isError: true)
        }

        let queryItems = optionalQueryItems(from: params, allowed: ["l"])
        let path = "v1/me/ratings/\(resourceType)/\(id)"

        do {
            let data = try await client.delete(path: path, queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleAddLibrarySongs(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }
        guard let idsValue = params.arguments?["ids"] else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }
        let ids = stringList(from: idsValue).joined(separator: ",")
        guard !ids.isEmpty else {
            return CallTool.Result(content: [.text("No IDs provided after parsing.")], isError: true)
        }

        var queryItems = [URLQueryItem(name: "ids[songs]", value: ids)]
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["l"]))

        do {
            let data = try await client.post(path: "v1/me/library", queryItems: queryItems, body: nil)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleAddLibraryAlbums(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }
        guard let idsValue = params.arguments?["ids"] else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }
        let ids = stringList(from: idsValue).joined(separator: ",")
        guard !ids.isEmpty else {
            return CallTool.Result(content: [.text("No IDs provided after parsing.")], isError: true)
        }

        var queryItems = [URLQueryItem(name: "ids[albums]", value: ids)]
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["l"]))

        do {
            let data = try await client.post(path: "v1/me/library", queryItems: queryItems, body: nil)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleAddFavorites(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let errorResult = requireUserToken() { return errorResult }

        var queryItems: [URLQueryItem] = []
        if let idsValue = params.arguments?["ids"] {
            let idsItems = idsQueryItems(from: idsValue, prefix: "ids")
            if !idsItems.isEmpty {
                queryItems.append(contentsOf: idsItems)
            } else {
                let ids = stringList(from: idsValue).joined(separator: ",")
                if !ids.isEmpty {
                    guard let resourceType = params.arguments?["resourceType"]?.stringValue, !resourceType.isEmpty else {
                        return CallTool.Result(
                            content: [.text("Missing required argument 'resourceType' when 'ids' is a string. Provide ids as an object keyed by resource type or include resourceType.")],
                            isError: true
                        )
                    }
                    queryItems.append(URLQueryItem(name: "ids[\(resourceType)]", value: ids))
                }
            }
        }

        guard !queryItems.isEmpty else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }

        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["l"]))

        do {
            let data = try await client.post(path: "v1/me/favorites", queryItems: queryItems, body: nil)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }
}

private let libraryTypeKeyMapping: [String: String] = [
    "library-songs": "library-songs",
    "library-albums": "library-albums",
    "library-artists": "library-artists",
    "library-playlists": "library-playlists",
    "library-playlist-folders": "library-playlist-folders",
    "library-music-videos": "library-music-videos",
    "songs": "library-songs",
    "albums": "library-albums",
    "artists": "library-artists",
    "playlists": "library-playlists",
    "playlist-folders": "library-playlist-folders",
    "music-videos": "library-music-videos"
]

private let libraryTypeKeys: Set<String> = [
    "library-songs",
    "library-albums",
    "library-artists",
    "library-playlists",
    "library-playlist-folders",
    "library-music-videos"
]

private let allowedRecommendationRelationships: Set<String> = ["contents"]
private let allowedReplayViews: Set<String> = ["top-artists", "top-albums", "top-songs"]

extension ToolRegistry {
    private func normalizeLibraryTypeKey(_ raw: String) -> String? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return libraryTypeKeyMapping[trimmed]
    }

    private func normalizeLibraryTypes(_ raw: [String]) -> (valid: [String], invalid: [String]) {
        var valid: [String] = []
        var invalid: [String] = []

        for value in raw {
            guard let normalized = normalizeLibraryTypeKey(value) else {
                let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty {
                    invalid.append(trimmed)
                }
                continue
            }
            if !valid.contains(normalized) {
                valid.append(normalized)
            }
        }

        return (valid, invalid)
    }

    private func buildReplayQueryItems(arguments: [String: Value]) -> ReplayQueryResult {
        guard let filterYear = arguments["filter[year]"]?.stringValue, !filterYear.isEmpty else {
                return .failure(CallTool.Result(content: [.text("Missing required argument 'filter[year]'. Must be 'latest' per Apple Music API.")], isError: true))
        }
        guard filterYear == "latest" else {
                return .failure(CallTool.Result(content: [.text("Invalid 'filter[year]' value. Per Apple Music API, use 'latest'.")], isError: true))
        }

        if let viewsValue = arguments["views"]?.stringValue, !viewsValue.isEmpty {
            let values = viewsValue
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
            let invalid = values.filter { !allowedReplayViews.contains($0) }
            if !invalid.isEmpty {
                let allowed = allowedReplayViews.sorted().joined(separator: ", ")
                return .failure(CallTool.Result(content: [.text("Invalid views: \(invalid.joined(separator: ", ")). Allowed: \(allowed).")], isError: true))
            }
        }

        let params = CallTool.Parameters(name: "get_replay_data", arguments: arguments)
        var queryItems: [URLQueryItem] = [URLQueryItem(name: "filter[year]", value: "latest")]
        queryItems.append(contentsOf: optionalQueryItems(from: params, allowed: ["include", "extend", "l", "views"]))
        return .success(queryItems)
    }
}

private enum ReplayQueryResult {
    case success([URLQueryItem])
    case failure(CallTool.Result)
}

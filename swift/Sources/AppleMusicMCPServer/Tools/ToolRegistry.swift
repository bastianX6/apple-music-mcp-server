import Foundation
import MCP

struct ToolRegistry: Sendable {
    let client: AppleMusicClientProtocol

    func handleGenericGet(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let rawPath = params.arguments?["path"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'path'.")], isError: true)
        }

        let path = rawPath.trimmingCharacters(in: CharacterSet(charactersIn: "/"))

        do {
            let data = try await client.get(path: path, queryItems: [])
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
            let data = try await client.get(path: "v1/me/storefront", queryItems: [])
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleSearchCatalog(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let term = params.arguments?["term"]?.stringValue?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return CallTool.Result(content: [.text("Missing required argument 'term'.")], isError: true)
        }
        let storefront = params.arguments?["storefront"]?.stringValue ?? "us"
        let types = params.arguments?["types"]?.stringValue ?? "songs,albums,artists,playlists"
        let limit = params.arguments?["limit"]?.intValue ?? 10
        let cappedLimit = max(1, min(limit, 25))

        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "types", value: types),
            URLQueryItem(name: "limit", value: String(cappedLimit))
        ]

        do {
            let data = try await client.get(path: "v1/catalog/\(storefront)/search", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetLibraryPlaylists(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard client.userToken != nil else {
            return CallTool.Result(
                content: [.text("User token is missing. Run the setup helper to acquire a Music-User-Token.")],
                isError: true
            )
        }

        let limit = params.arguments?["limit"]?.intValue ?? 25
        let offset = params.arguments?["offset"]?.intValue ?? 0
        let cappedLimit = max(1, min(limit, 100))
        let cappedOffset = max(0, offset)

        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: String(cappedLimit)),
            URLQueryItem(name: "offset", value: String(cappedOffset))
        ]

        do {
            let data = try await client.get(path: "v1/me/library/playlists", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetCatalogSongs(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let ids = params.arguments?["ids"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }

        let storefront = params.arguments?["storefront"]?.stringValue ?? "us"
        let limit = params.arguments?["limit"]?.intValue ?? 10
        let cappedLimit = max(1, min(limit, 25))

        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "ids", value: ids),
            URLQueryItem(name: "limit", value: String(cappedLimit))
        ]

        do {
            let data = try await client.get(path: "v1/catalog/\(storefront)/songs", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetLibrarySongs(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard client.userToken != nil else {
            return CallTool.Result(
                content: [.text("User token is missing. Run the setup helper to acquire a Music-User-Token.")],
                isError: true
            )
        }

        let limit = params.arguments?["limit"]?.intValue ?? 25
        let offset = params.arguments?["offset"]?.intValue ?? 0
        let cappedLimit = max(1, min(limit, 100))
        let cappedOffset = max(0, offset)

        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: String(cappedLimit)),
            URLQueryItem(name: "offset", value: String(cappedOffset))
        ]

        do {
            let data = try await client.get(path: "v1/me/library/songs", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetCatalogAlbums(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let ids = params.arguments?["ids"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }

        let storefront = params.arguments?["storefront"]?.stringValue ?? "us"
        let limit = params.arguments?["limit"]?.intValue ?? 10
        let cappedLimit = max(1, min(limit, 25))

        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "ids", value: ids),
            URLQueryItem(name: "limit", value: String(cappedLimit))
        ]

        do {
            let data = try await client.get(path: "v1/catalog/\(storefront)/albums", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetCatalogArtists(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let ids = params.arguments?["ids"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }

        let storefront = params.arguments?["storefront"]?.stringValue ?? "us"
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "ids", value: ids)
        ]

        do {
            let data = try await client.get(path: "v1/catalog/\(storefront)/artists", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetCatalogPlaylists(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let ids = params.arguments?["ids"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }

        let storefront = params.arguments?["storefront"]?.stringValue ?? "us"
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "ids", value: ids)
        ]

        do {
            let data = try await client.get(path: "v1/catalog/\(storefront)/playlists", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetCurators(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let ids = params.arguments?["ids"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }

        let storefront = params.arguments?["storefront"]?.stringValue ?? "us"
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "ids", value: ids)
        ]

        do {
            let data = try await client.get(path: "v1/catalog/\(storefront)/curators", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetActivities(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let ids = params.arguments?["ids"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }

        let storefront = params.arguments?["storefront"]?.stringValue ?? "us"
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "ids", value: ids)
        ]

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
        guard let ids = params.arguments?["ids"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }

        let storefront = params.arguments?["storefront"]?.stringValue ?? "us"
        let path = "v1/catalog/\(storefront)/\(type)"
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "ids", value: ids)]

        do {
            let data = try await client.get(path: path, queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetRecordLabels(params: CallTool.Parameters) async throws -> CallTool.Result {
        let message = "Record labels are not exposed as resources in the Apple Music API. No request was sent."
        return CallTool.Result(content: [.text(message)], isError: true)
    }

    func handleGetRadioShows(params: CallTool.Parameters) async throws -> CallTool.Result {
        let message = "Radio shows endpoint returns 404 in Apple Music API. Use stations instead. No request was sent."
        return CallTool.Result(content: [.text(message)], isError: true)
    }

    func handleGetLibraryAlbums(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard client.userToken != nil else {
            return CallTool.Result(
                content: [.text("User token is missing. Run the setup helper to acquire a Music-User-Token.")],
                isError: true
            )
        }

        let limit = params.arguments?["limit"]?.intValue ?? 25
        let offset = params.arguments?["offset"]?.intValue ?? 0
        let cappedLimit = max(1, min(limit, 100))
        let cappedOffset = max(0, offset)

        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: String(cappedLimit)),
            URLQueryItem(name: "offset", value: String(cappedOffset))
        ]

        do {
            let data = try await client.get(path: "v1/me/library/albums", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetLibraryArtists(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard client.userToken != nil else {
            return CallTool.Result(
                content: [.text("User token is missing. Run the setup helper to acquire a Music-User-Token.")],
                isError: true
            )
        }

        let limit = params.arguments?["limit"]?.intValue ?? 25
        let offset = params.arguments?["offset"]?.intValue ?? 0
        let cappedLimit = max(1, min(limit, 100))
        let cappedOffset = max(0, offset)

        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: String(cappedLimit)),
            URLQueryItem(name: "offset", value: String(cappedOffset))
        ]

        do {
            let data = try await client.get(path: "v1/me/library/artists", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetLibraryResources(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard client.userToken != nil else {
            return CallTool.Result(
                content: [.text("User token is missing. Run the setup helper to acquire a Music-User-Token.")],
                isError: true
            )
        }
        guard let type = params.arguments?["type"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'type'.")], isError: true)
        }
        guard let ids = params.arguments?["ids"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }

        let path = "v1/me/library/\(type)"
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "ids", value: ids)]

        do {
            let data = try await client.get(path: path, queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetRecentlyPlayed(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard client.userToken != nil else {
            return CallTool.Result(
                content: [.text("User token is missing. Run the setup helper to acquire a Music-User-Token.")],
                isError: true
            )
        }

        let limit = params.arguments?["limit"]?.intValue ?? 10
        let cappedLimit = max(1, min(limit, 100))

        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: String(cappedLimit))
        ]

        do {
            let data = try await client.get(path: "v1/me/recent/played", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetMusicVideos(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let ids = params.arguments?["ids"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }

        let storefront = params.arguments?["storefront"]?.stringValue ?? "us"
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "ids", value: ids)
        ]

        do {
            let data = try await client.get(path: "v1/catalog/\(storefront)/music-videos", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetGenres(params: CallTool.Parameters) async throws -> CallTool.Result {
        let storefront = params.arguments?["storefront"]?.stringValue ?? "us"

        do {
            let data = try await client.get(path: "v1/catalog/\(storefront)/genres", queryItems: [])
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetCharts(params: CallTool.Parameters) async throws -> CallTool.Result {
        let storefront = params.arguments?["storefront"]?.stringValue ?? "us"
        let types = params.arguments?["types"]?.stringValue ?? "songs,albums,playlists"
        let chart = params.arguments?["chart"]?.stringValue ?? "most-played"
        let limit = params.arguments?["limit"]?.intValue ?? 10
        let cappedLimit = max(1, min(limit, 50))

        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "types", value: types),
            URLQueryItem(name: "chart", value: chart),
            URLQueryItem(name: "limit", value: String(cappedLimit))
        ]

        do {
            let data = try await client.get(path: "v1/catalog/\(storefront)/charts", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetStations(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let ids = params.arguments?["ids"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }

        let storefront = params.arguments?["storefront"]?.stringValue ?? "us"
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "ids", value: ids)
        ]

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
        let storefront = params.arguments?["storefront"]?.stringValue ?? "us"
        let kinds = params.arguments?["kinds"]?.stringValue ?? "terms"

        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "kinds", value: kinds)
        ]

        do {
            let data = try await client.get(path: "v1/catalog/\(storefront)/search/suggestions", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetRecommendations(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard client.userToken != nil else {
            return CallTool.Result(
                content: [.text("User token is missing. Run the setup helper to acquire a Music-User-Token.")],
                isError: true
            )
        }

        let limit = params.arguments?["limit"]?.intValue ?? 10
        let cappedLimit = max(1, min(limit, 50))

        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: String(cappedLimit))
        ]

        do {
            let data = try await client.get(path: "v1/me/recommendations", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetHeavyRotation(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard client.userToken != nil else {
            return CallTool.Result(
                content: [.text("User token is missing. Run the setup helper to acquire a Music-User-Token.")],
                isError: true
            )
        }

        let limit = params.arguments?["limit"]?.intValue ?? 10
        let cappedLimit = max(1, min(limit, 100))

        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: String(cappedLimit))
        ]

        do {
            let data = try await client.get(path: "v1/me/history/heavy-rotation", queryItems: queryItems)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleGetReplay(params: CallTool.Parameters) async throws -> CallTool.Result {
        let message = "Replay data endpoint (/v1/me/replay) is not available (Apple returns 404). No request was sent."
        return CallTool.Result(content: [.text(message)], isError: true)
    }

    func handleCreatePlaylist(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard client.userToken != nil else {
            return CallTool.Result(
                content: [.text("User token is missing. Run the setup helper to acquire a Music-User-Token.")],
                isError: true
            )
        }
        guard let name = params.arguments?["name"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'name'.")], isError: true)
        }
        let description = params.arguments?["description"]?.stringValue

        let bodyDict: [String: Any] = {
            var attributes: [String: Any] = ["name": name]
            if let description { attributes["description"] = description }
            return [
                "attributes": attributes
            ]
        }()

        guard let body = try? JSONSerialization.data(withJSONObject: bodyDict, options: []) else {
            return CallTool.Result(content: [.text("Failed to encode request body.")], isError: true)
        }

        do {
            let data = try await client.post(path: "v1/me/library/playlists", body: body)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleAddPlaylistTracks(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard client.userToken != nil else {
            return CallTool.Result(
                content: [.text("User token is missing. Run the setup helper to acquire a Music-User-Token.")],
                isError: true
            )
        }
        guard let playlistId = params.arguments?["playlistId"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'playlistId'.")], isError: true)
        }
        guard let trackIdsRaw = params.arguments?["trackIds"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'trackIds'.")], isError: true)
        }

        let ids = trackIdsRaw.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
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
            let data = try await client.post(path: path, body: body)
            let text = prettyPrintedJSON(data) ?? String(data: data, encoding: .utf8) ?? ""
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch {
            return CallTool.Result(content: [.text("Request failed: \(error.localizedDescription)")], isError: true)
        }
    }

    func handleAddLibrarySongs(params: CallTool.Parameters) async throws -> CallTool.Result {
        let message = "Apple Music API returns 405 for adding songs to library. No request was sent."
        return CallTool.Result(content: [.text(message)], isError: true)
    }

    func handleAddLibraryAlbums(params: CallTool.Parameters) async throws -> CallTool.Result {
        let message = "Apple Music API returns 405 for adding albums to library. No request was sent."
        return CallTool.Result(content: [.text(message)], isError: true)
    }

    func handleAddFavorites(params: CallTool.Parameters) async throws -> CallTool.Result {
        let message = "Apple Music API returns 405 for favorites. No request was sent."
        return CallTool.Result(content: [.text(message)], isError: true)
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

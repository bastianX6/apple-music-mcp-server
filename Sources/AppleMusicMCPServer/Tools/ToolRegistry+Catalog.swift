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

    func handleGetCatalogSongs(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let ids = params.arguments?["ids"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }

        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
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

    func handleGetCatalogAlbums(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let ids = params.arguments?["ids"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }

        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
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

        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
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

        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
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

        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
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

        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
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

        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
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

    func handleGetMusicVideos(params: CallTool.Parameters) async throws -> CallTool.Result {
        guard let ids = params.arguments?["ids"]?.stringValue else {
            return CallTool.Result(content: [.text("Missing required argument 'ids'.")], isError: true)
        }

        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
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
        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }

        do {
            let data = try await client.get(path: "v1/catalog/\(storefront)/genres", queryItems: [])
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

        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
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
        let storefrontResult = await resolveStorefront(params.arguments?["storefront"]?.stringValue)
        guard case let .success(storefront) = storefrontResult else { return storefrontResult.errorResult }
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

    func handleGetRecordLabels(params: CallTool.Parameters) async throws -> CallTool.Result {
        let message = "Record labels are not exposed as resources in the Apple Music API. No request was sent."
        return CallTool.Result(content: [.text(message)], isError: true)
    }

    func handleGetRadioShows(params: CallTool.Parameters) async throws -> CallTool.Result {
        let message = "Radio shows endpoint returns 404 in Apple Music API. Use stations instead. No request was sent."
        return CallTool.Result(content: [.text(message)], isError: true)
    }
}

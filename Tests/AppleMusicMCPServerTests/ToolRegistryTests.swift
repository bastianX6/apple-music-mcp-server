import XCTest
import MCP
@testable import AppleMusicMCPServer

final class ToolRegistryTests: XCTestCase {
    // Simple stub client to capture requests without network.
    final class StubAppleMusicClient: AppleMusicClientProtocol, @unchecked Sendable {
        var userToken: String?
        var lastGetPath: String?
        var lastGetQueryItems: [URLQueryItem] = []
        var lastPostPath: String?
        var lastPostBody: Data?
        var getResponse: Data
        var postResponse: Data

        init(userToken: String?, getResponse: Data = "{\"ok\":true}".data(using: .utf8)!, postResponse: Data? = nil) {
            self.userToken = userToken
            self.getResponse = getResponse
            self.postResponse = postResponse ?? getResponse
        }

        func get(path: String, queryItems: [URLQueryItem]) async throws -> Data {
            lastGetPath = path
            lastGetQueryItems = queryItems
            if path == "v1/me/storefront" {
                return Data(#"{"data":[{"id":"us"}]}"#.utf8)
            }
            return getResponse
        }

        func post(path: String, body: Data?) async throws -> Data {
            lastPostPath = path
            lastPostBody = body
            return postResponse
        }
    }

    private func makeRegistry(userToken: String? = "user") -> (ToolRegistry, StubAppleMusicClient) {
        let stub = StubAppleMusicClient(userToken: userToken)
        return (ToolRegistry(client: stub), stub)
    }

    private func text(_ result: CallTool.Result) -> String {
        result.content.compactMap { content -> String? in
            if case let .text(value) = content { return value }
            return nil
        }.joined(separator: "\n")
    }

    private func queryDict(_ items: [URLQueryItem]) -> [String: String] {
        items.reduce(into: [:]) { dict, item in
            if let value = item.value { dict[item.name] = value }
        }
    }

    func testGenericGetTrimsLeadingSlash() async throws {
        let (registry, stub) = makeRegistry()
        let params = CallTool.Parameters(name: "generic_get", arguments: ["path": .string("/v1/catalog/us/songs?id=1")])

        let result = try await registry.handleGenericGet(params: params)

        XCTAssertEqual(result.isError, false)
        XCTAssertEqual(stub.lastGetPath, "v1/catalog/us/songs")
        let dict = queryDict(stub.lastGetQueryItems)
        XCTAssertEqual(dict["id"], "1")
    }

    func testUserStorefrontRequiresUserToken() async throws {
        let (registry, _) = makeRegistry(userToken: nil)
        let result = try await registry.handleGetUserStorefront()

        XCTAssertEqual(result.isError, true)
        XCTAssertTrue(text(result).contains("User token is missing"))
    }

    func testUserStorefrontCallsEndpoint() async throws {
        let (registry, stub) = makeRegistry(userToken: "user")

        let result = try await registry.handleGetUserStorefront()

        XCTAssertEqual(result.isError, false)
        XCTAssertEqual(stub.lastGetPath, "v1/me/storefront")
        XCTAssertTrue(stub.lastGetQueryItems.isEmpty)
    }

    func testSearchCatalogEncodesTermAndCapsLimit() async throws {
        let (registry, stub) = makeRegistry()
        let params = CallTool.Parameters(name: "search_catalog", arguments: [
            "term": .string("café"),
            "limit": .int(50)
        ])

        let result = try await registry.handleSearchCatalog(params: params)

        XCTAssertEqual(result.isError, false)
        XCTAssertEqual(stub.lastGetPath, "v1/catalog/us/search")
        let dict = queryDict(stub.lastGetQueryItems)
        XCTAssertEqual(dict["term"], "caf%C3%A9")
        XCTAssertEqual(dict["limit"], "25") // capped at 25
    }

    func testLibraryPlaylistsRequiresUserToken() async throws {
        let (registry, _) = makeRegistry(userToken: nil)
        let params = CallTool.Parameters(name: "get_library_playlists")

        let result = try await registry.handleGetLibraryPlaylists(params: params)

        XCTAssertEqual(result.isError, true)
        XCTAssertTrue(text(result).contains("User token is missing"))
    }

    func testLibraryPlaylistsCapsPagination() async throws {
        let (registry, stub) = makeRegistry(userToken: "user")
        let params = CallTool.Parameters(name: "get_library_playlists", arguments: [
            "limit": .int(150),
            "offset": .int(-5)
        ])

        let result = try await registry.handleGetLibraryPlaylists(params: params)

        XCTAssertEqual(result.isError, false)
        let dict = queryDict(stub.lastGetQueryItems)
        XCTAssertEqual(dict["limit"], "100")
        XCTAssertEqual(dict["offset"], "0")
        XCTAssertEqual(stub.lastGetPath, "v1/me/library/playlists")
    }

    func testCatalogSongsRequiresIds() async throws {
        let (registry, _) = makeRegistry()
        let params = CallTool.Parameters(name: "get_catalog_songs")

        let result = try await registry.handleGetCatalogSongs(params: params)

        XCTAssertEqual(result.isError, true)
        XCTAssertTrue(text(result).contains("Missing required argument 'ids'."))
    }

    func testCatalogSongsCapsLimit() async throws {
        let (registry, stub) = makeRegistry()
        let params = CallTool.Parameters(name: "get_catalog_songs", arguments: [
            "ids": .string("1,2"),
            "limit": .int(40),
            "storefront": .string("jp")
        ])

        let result = try await registry.handleGetCatalogSongs(params: params)

        XCTAssertEqual(result.isError, false)
        XCTAssertEqual(stub.lastGetPath, "v1/catalog/us/songs")
        let dict = queryDict(stub.lastGetQueryItems)
        XCTAssertEqual(dict["limit"], "25")
        XCTAssertEqual(dict["ids"], "1,2")
    }

    func testLibrarySongsRequiresUserToken() async throws {
        let (registry, _) = makeRegistry(userToken: nil)
        let params = CallTool.Parameters(name: "get_library_songs")

        let result = try await registry.handleGetLibrarySongs(params: params)

        XCTAssertEqual(result.isError, true)
        XCTAssertTrue(text(result).contains("User token is missing"))
    }

    func testCatalogResourcesRequiresTypeAndIds() async throws {
        let (registry, _) = makeRegistry()
        let missingType = CallTool.Parameters(name: "get_catalog_resources", arguments: ["ids": .string("1")])
        let missingIds = CallTool.Parameters(name: "get_catalog_resources", arguments: ["type": .string("songs")])

        let missingTypeResult = try await registry.handleGetCatalogResources(params: missingType)
        let missingIdsResult = try await registry.handleGetCatalogResources(params: missingIds)

        XCTAssertEqual(missingTypeResult.isError, true)
        XCTAssertTrue(text(missingTypeResult).contains("Missing required argument 'type'."))
        XCTAssertEqual(missingIdsResult.isError, true)
        XCTAssertTrue(text(missingIdsResult).contains("Missing required argument 'ids'."))
    }

    func testCatalogResourcesUsesTypeAndIds() async throws {
        let (registry, stub) = makeRegistry()
        let params = CallTool.Parameters(name: "get_catalog_resources", arguments: [
            "type": .string("stations"),
            "ids": .string("abc,def"),
            "storefront": .string("gb")
        ])

        let result = try await registry.handleGetCatalogResources(params: params)

        XCTAssertEqual(result.isError, false)
        XCTAssertEqual(stub.lastGetPath, "v1/catalog/us/stations")
        let dict = queryDict(stub.lastGetQueryItems)
        XCTAssertEqual(dict["ids"], "abc,def")
    }

    func testRecordLabelsReturnsInformativeError() async throws {
        let (registry, stub) = makeRegistry()
        let params = CallTool.Parameters(name: "get_record_labels")

        let result = try await registry.handleGetRecordLabels(params: params)

        XCTAssertEqual(result.isError, true)
        XCTAssertTrue(text(result).contains("Record labels"))
        XCTAssertNil(stub.lastGetPath)
    }

    func testRadioShowsReturnsInformativeError() async throws {
        let (registry, stub) = makeRegistry()
        let params = CallTool.Parameters(name: "get_radio_shows")

        let result = try await registry.handleGetRadioShows(params: params)

        XCTAssertEqual(result.isError, true)
        XCTAssertTrue(text(result).contains("Radio shows endpoint"))
        XCTAssertNil(stub.lastGetPath)
    }

    func testLibraryAlbumsRequiresUserToken() async throws {
        let (registry, _) = makeRegistry(userToken: nil)
        let params = CallTool.Parameters(name: "get_library_albums")

        let result = try await registry.handleGetLibraryAlbums(params: params)

        XCTAssertEqual(result.isError, true)
        XCTAssertTrue(text(result).contains("User token is missing"))
    }

    func testLibraryResourcesRequiresUserToken() async throws {
        let (registry, _) = makeRegistry(userToken: nil)
        let params = CallTool.Parameters(name: "get_library_resources", arguments: ["type": .string("songs"), "ids": .string("1")])

        let result = try await registry.handleGetLibraryResources(params: params)

        XCTAssertEqual(result.isError, true)
        XCTAssertTrue(text(result).contains("User token is missing"))
    }

    func testLibraryResourcesRequiresIds() async throws {
        let (registry, _) = makeRegistry(userToken: "user")
        let params = CallTool.Parameters(name: "get_library_resources", arguments: ["type": .string("songs")])

        let result = try await registry.handleGetLibraryResources(params: params)

        XCTAssertEqual(result.isError, true)
        XCTAssertTrue(text(result).contains("Missing required argument 'ids'."))
    }

    func testRecentlyPlayedRequiresUserToken() async throws {
        let (registry, _) = makeRegistry(userToken: nil)
        let params = CallTool.Parameters(name: "get_recently_played")

        let result = try await registry.handleGetRecentlyPlayed(params: params)

        XCTAssertEqual(result.isError, true)
        XCTAssertTrue(text(result).contains("User token is missing"))
    }

    func testMusicVideosRequiresIds() async throws {
        let (registry, _) = makeRegistry()
        let params = CallTool.Parameters(name: "get_music_videos")

        let result = try await registry.handleGetMusicVideos(params: params)

        XCTAssertEqual(result.isError, true)
        XCTAssertTrue(text(result).contains("Missing required argument 'ids'."))
    }

    func testGenresUsesDefaultStorefront() async throws {
        let (registry, stub) = makeRegistry()
        let params = CallTool.Parameters(name: "get_genres")

        let result = try await registry.handleGetGenres(params: params)

        XCTAssertEqual(result.isError, false)
        XCTAssertEqual(stub.lastGetPath, "v1/catalog/us/genres")
        XCTAssertTrue(stub.lastGetQueryItems.isEmpty)
    }

    func testChartsCapsLimit() async throws {
        let (registry, stub) = makeRegistry()
        let params = CallTool.Parameters(name: "get_charts", arguments: [
            "limit": .int(80),
            "storefront": .string("ca"),
            "types": .string("songs"),
            "chart": .string("most-played")
        ])

        let result = try await registry.handleGetCharts(params: params)

        XCTAssertEqual(result.isError, false)
        XCTAssertEqual(stub.lastGetPath, "v1/catalog/us/charts")
        XCTAssertEqual(queryDict(stub.lastGetQueryItems)["limit"], "50")
    }

    func testStationsRequiresIds() async throws {
        let (registry, _) = makeRegistry()
        let params = CallTool.Parameters(name: "get_stations")

        let result = try await registry.handleGetStations(params: params)

        XCTAssertEqual(result.isError, true)
        XCTAssertTrue(text(result).contains("Missing required argument 'ids'."))
    }

    func testSearchSuggestionsRequiresTerm() async throws {
        let (registry, _) = makeRegistry()
        let params = CallTool.Parameters(name: "get_search_suggestions")

        let result = try await registry.handleGetSearchSuggestions(params: params)

        XCTAssertEqual(result.isError, true)
        XCTAssertTrue(text(result).contains("Missing required argument 'term'."))
    }

    func testRecommendationsRequiresUserToken() async throws {
        let (registry, _) = makeRegistry(userToken: nil)
        let params = CallTool.Parameters(name: "get_recommendations")

        let result = try await registry.handleGetRecommendations(params: params)

        XCTAssertEqual(result.isError, true)
        XCTAssertTrue(text(result).contains("User token is missing"))
    }

    func testHeavyRotationRequiresUserToken() async throws {
        let (registry, _) = makeRegistry(userToken: nil)
        let params = CallTool.Parameters(name: "get_heavy_rotation")

        let result = try await registry.handleGetHeavyRotation(params: params)

        XCTAssertEqual(result.isError, true)
        XCTAssertTrue(text(result).contains("User token is missing"))
    }

    func testCreatePlaylistEncodesNameAndDescription() async throws {
        let (registry, stub) = makeRegistry(userToken: "user")
        let params = CallTool.Parameters(name: "create_playlist", arguments: [
            "name": .string("Focus"),
            "description": .string("Deep work")
        ])

        let result = try await registry.handleCreatePlaylist(params: params)

        XCTAssertEqual(result.isError, false)
        XCTAssertEqual(stub.lastPostPath, "v1/me/library/playlists")

        let body = try XCTUnwrap(stub.lastPostBody)
        let json = try JSONSerialization.jsonObject(with: body, options: []) as? [String: Any]
        let attributes = json?["attributes"] as? [String: Any]
        XCTAssertEqual(attributes?["name"] as? String, "Focus")
        XCTAssertEqual(attributes?["description"] as? String, "Deep work")
    }

    func testAddPlaylistTracksParsesTrackIds() async throws {
        let (registry, stub) = makeRegistry(userToken: "user")
        let params = CallTool.Parameters(name: "add_playlist_tracks", arguments: [
            "playlistId": .string("pl.123"),
            "trackIds": .string("1, 2 ,3 ")
        ])

        let result = try await registry.handleAddPlaylistTracks(params: params)

        XCTAssertEqual(result.isError, false)
        XCTAssertEqual(stub.lastPostPath, "v1/me/library/playlists/pl.123/tracks")

        let body = try XCTUnwrap(stub.lastPostBody)
        let json = try JSONSerialization.jsonObject(with: body, options: []) as? [String: Any]
        let data = json?["data"] as? [[String: Any]]
        XCTAssertEqual(data?.count, 3)
        XCTAssertTrue(data?.allSatisfy { $0["type"] as? String == "songs" } ?? false)
        XCTAssertEqual(data?.compactMap { $0["id"] as? String }, ["1", "2", "3"])
    }

    func testAddLibraryAlbumsReturnsMessage() async throws {
        let (registry, _) = makeRegistry(userToken: "user")
        let params = CallTool.Parameters(name: "add_library_albums")

        let result = try await registry.handleAddLibraryAlbums(params: params)

        XCTAssertEqual(result.isError, true)
        XCTAssertTrue(text(result).contains("405"))
    }

    func testAddFavoritesReturnsMessage() async throws {
        let (registry, _) = makeRegistry(userToken: "user")
        let params = CallTool.Parameters(name: "add_favorites")

        let result = try await registry.handleAddFavorites(params: params)

        XCTAssertEqual(result.isError, true)
        XCTAssertTrue(text(result).contains("405"))
    }
}

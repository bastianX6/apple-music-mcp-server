import XCTest
import MCP
@testable import AppleMusicTool
@testable import AppleMusicCore

final class AppleMusicToolCLIStubTests: XCTestCase {
    final class StubClient: AppleMusicClientProtocol, @unchecked Sendable {
        var userToken: String? = nil
        var lastPath: String?
        var lastQuery: [URLQueryItem] = []
        var lastMethod: String?
        var lastBody: Data?
        var response: Data = Data("{\"ok\":true}".utf8)

        func get(path: String, queryItems: [URLQueryItem]) async throws -> Data {
            lastMethod = "GET"
            lastPath = path
            lastQuery = queryItems
            lastBody = nil
            if path == "v1/me/storefront" { return Data("{\"data\":[{\"id\":\"us\"}]}".utf8) }
            return response
        }
        func post(path: String, queryItems: [URLQueryItem], body: Data?) async throws -> Data {
            lastMethod = "POST"
            lastPath = path
            lastQuery = queryItems
            lastBody = body
            return response
        }
        func put(path: String, queryItems: [URLQueryItem], body: Data?) async throws -> Data {
            lastMethod = "PUT"
            lastPath = path
            lastQuery = queryItems
            lastBody = body
            return response
        }
        func delete(path: String, queryItems: [URLQueryItem]) async throws -> Data {
            lastMethod = "DELETE"
            lastPath = path
            lastQuery = queryItems
            lastBody = nil
            return response
        }
    }

    func testSearchCatalogCommandBuildsQuery() async throws {
        let client = StubClient()
        var capturedOutput = ""
        let runner = ToolRunner(configPath: nil, beautify: false, client: client, stdout: { capturedOutput = $0 }, stderr: { _ in })
        try await runner.run(toolName: "search_catalog", arguments: [
            "term": .string("focus"),
            "types": .string("songs"),
            "limit": .int(5)
        ])
        XCTAssertEqual(client.lastPath, "v1/catalog/us/search")
        let dict = client.lastQuery.reduce(into: [:]) { $0[$1.name] = $1.value }
        XCTAssertEqual(dict["term"], "focus")
        XCTAssertTrue(capturedOutput.contains("ok"))
    }

    func testGetCatalogAlbumsBuildsPath() async throws {
        let client = StubClient()
        let runner = ToolRunner(configPath: nil, beautify: false, client: client, stdout: { _ in }, stderr: { _ in })
        try await runner.run(toolName: "get_catalog_albums", arguments: [
            "ids": .string("1,2"),
            "storefront": .string("jp")
        ])
        XCTAssertEqual(client.lastPath, "v1/catalog/jp/albums")
        let dict = client.lastQuery.reduce(into: [:]) { $0[$1.name] = $1.value }
        XCTAssertEqual(dict["ids"], "1,2")
    }

    func testGetCatalogArtistsUsesIds() async throws {
        let client = StubClient()
        let runner = ToolRunner(configPath: nil, beautify: false, client: client, stdout: { _ in }, stderr: { _ in })
        try await runner.run(toolName: "get_catalog_artists", arguments: [
            "ids": .string("a1,b2")
        ])
        XCTAssertEqual(client.lastPath, "v1/catalog/us/artists")
        let dict = client.lastQuery.reduce(into: [:]) { $0[$1.name] = $1.value }
        XCTAssertEqual(dict["ids"], "a1,b2")
    }

    func testGetCatalogResourcesBuildsType() async throws {
        let client = StubClient()
        let runner = ToolRunner(configPath: nil, beautify: false, client: client, stdout: { _ in }, stderr: { _ in })
        try await runner.run(toolName: "get_catalog_resources", arguments: [
            "type": .string("stations"),
            "ids": .string("s1")
        ])
        XCTAssertEqual(client.lastPath, "v1/catalog/us/stations")
    }

    func testLibraryResourcesRespectsType() async throws {
        let client = StubClient()
        client.userToken = "user"
        let runner = ToolRunner(configPath: nil, beautify: false, client: client, stdout: { _ in }, stderr: { _ in })
        try await runner.run(toolName: "get_library_resources", arguments: [
            "type": .string("songs"),
            "limit": .int(3)
        ])
        XCTAssertEqual(client.lastPath, "v1/me/library/songs")
    }

    func testGetRecommendationsUsesPath() async throws {
        let client = StubClient()
        client.userToken = "user"
        let runner = ToolRunner(configPath: nil, beautify: false, client: client, stdout: { _ in }, stderr: { _ in })
        try await runner.run(toolName: "get_recommendations", arguments: [:])
        XCTAssertEqual(client.lastPath, "v1/me/recommendations")
    }

    func testGetRecentlyPlayedTracksUsesPath() async throws {
        let client = StubClient()
        client.userToken = "user"
        let runner = ToolRunner(configPath: nil, beautify: false, client: client, stdout: { _ in }, stderr: { _ in })
        try await runner.run(toolName: "get_recently_played_tracks", arguments: [:])
        XCTAssertEqual(client.lastPath, "v1/me/recent/played/tracks")
    }

    func testGetRecordLabelsReturnsErrorEnvelope() async throws {
        let client = StubClient()
        var errorOutput = ""
        let runner = ToolRunner(configPath: nil, beautify: true, client: client, stdout: { _ in }, stderr: { errorOutput = $0 })
        do {
            try await runner.run(toolName: "get_record_labels", arguments: [:])
            XCTFail("Expected failure")
        } catch {
            // expected
        }
        XCTAssertTrue(errorOutput.contains("tool-error"))
    }

    func testCreatePlaylistBuildsBody() async throws {
        let client = StubClient()
        client.userToken = "user"
        var captured = ""
        let runner = ToolRunner(configPath: nil, beautify: false, client: client, stdout: { captured = $0 }, stderr: { _ in })
        try await runner.run(toolName: "create_playlist", arguments: [
            "name": .string("My Playlist"),
            "description": .string("Desc"),
            "tracks": .string("1,2"),
            "parent": .string("folder1")
        ])

        XCTAssertEqual(client.lastMethod, "POST")
        XCTAssertEqual(client.lastPath, "v1/me/library/playlists")
        let body = try XCTUnwrap(client.lastBody)
        let json = try JSONSerialization.jsonObject(with: body) as? [String: Any]
        let attrs = json?["attributes"] as? [String: Any]
        XCTAssertEqual(attrs?["name"] as? String, "My Playlist")
        XCTAssertEqual(attrs?["description"] as? String, "Desc")
        let relationships = json?["relationships"] as? [String: Any]
        let parent = relationships?["parent"] as? [String: Any]
        XCTAssertEqual((parent?["data"] as? [String: Any])?["id"] as? String, "folder1")
        let tracks = relationships?["tracks"] as? [String: Any]
        let data = tracks?["data"] as? [[String: Any]]
        XCTAssertEqual(data?.count, 2)
        XCTAssertTrue(captured.contains("ok"))
    }

    func testAddPlaylistTracksBuildsPath() async throws {
        let client = StubClient()
        client.userToken = "user"
        let runner = ToolRunner(configPath: nil, beautify: false, client: client, stdout: { _ in }, stderr: { _ in })
        try await runner.run(toolName: "add_playlist_tracks", arguments: [
            "playlistId": .string("pl1"),
            "trackIds": .string("s1,s2")
        ])

        XCTAssertEqual(client.lastMethod, "POST")
        XCTAssertEqual(client.lastPath, "v1/me/library/playlists/pl1/tracks")
        let body = try XCTUnwrap(client.lastBody)
        let json = try JSONSerialization.jsonObject(with: body) as? [String: Any]
        let data = json?["data"] as? [[String: Any]]
        XCTAssertEqual(data?.count, 2)
    }

    func testCreatePlaylistFolderBuildsPath() async throws {
        let client = StubClient()
        client.userToken = "user"
        let runner = ToolRunner(configPath: nil, beautify: false, client: client, stdout: { _ in }, stderr: { _ in })
        try await runner.run(toolName: "create_playlist_folder", arguments: [
            "name": .string("Folder")
        ])

        XCTAssertEqual(client.lastMethod, "POST")
        XCTAssertEqual(client.lastPath, "v1/me/library/playlist-folders")
    }

    func testAddLibraryResourcesSupportsTypedIds() async throws {
        let client = StubClient()
        client.userToken = "user"
        let runner = ToolRunner(configPath: nil, beautify: false, client: client, stdout: { _ in }, stderr: { _ in })
        try await runner.run(toolName: "add_library_resources", arguments: [
            "ids": .object(["songs": .string("1,2"), "albums": .string("3")]),
            "l": .string("es")
        ])

        XCTAssertEqual(client.lastMethod, "POST")
        XCTAssertEqual(client.lastPath, "v1/me/library")
        let query = client.lastQuery.reduce(into: [:]) { $0[$1.name] = $1.value }
        XCTAssertEqual(query["ids[songs]"], "1,2")
        XCTAssertEqual(query["ids[albums]"], "3")
        XCTAssertEqual(query["l"], "es")
    }

    func testAddLibraryResourcesSupportsCsvAndResourceType() async throws {
        let client = StubClient()
        client.userToken = "user"
        let runner = ToolRunner(configPath: nil, beautify: false, client: client, stdout: { _ in }, stderr: { _ in })
        try await runner.run(toolName: "add_library_resources", arguments: [
            "ids": .string("9,10"),
            "resourceType": .string("songs")
        ])

        let query = client.lastQuery.reduce(into: [:]) { $0[$1.name] = $1.value }
        XCTAssertEqual(query["ids[songs]"], "9,10")
    }

    func testAddLibrarySongsBuildsQuery() async throws {
        let client = StubClient()
        client.userToken = "user"
        let runner = ToolRunner(configPath: nil, beautify: false, client: client, stdout: { _ in }, stderr: { _ in })
        try await runner.run(toolName: "add_library_songs", arguments: [
            "ids": .string("a,b"),
            "l": .string("en")
        ])
        XCTAssertEqual(client.lastPath, "v1/me/library")
        let query = client.lastQuery.reduce(into: [:]) { $0[$1.name] = $1.value }
        XCTAssertEqual(query["ids[songs]"], "a,b")
        XCTAssertEqual(query["l"], "en")
    }

    func testAddLibraryAlbumsBuildsQuery() async throws {
        let client = StubClient()
        client.userToken = "user"
        let runner = ToolRunner(configPath: nil, beautify: false, client: client, stdout: { _ in }, stderr: { _ in })
        try await runner.run(toolName: "add_library_albums", arguments: [
            "ids": .string("x,y")
        ])
        XCTAssertEqual(client.lastPath, "v1/me/library")
        let query = client.lastQuery.reduce(into: [:]) { $0[$1.name] = $1.value }
        XCTAssertEqual(query["ids[albums]"], "x,y")
    }

    func testAddFavoritesSupportsTypedIds() async throws {
        let client = StubClient()
        client.userToken = "user"
        let runner = ToolRunner(configPath: nil, beautify: false, client: client, stdout: { _ in }, stderr: { _ in })
        try await runner.run(toolName: "add_favorites", arguments: [
            "ids": .object(["songs": .string("1"), "albums": .string("2")])
        ])

        XCTAssertEqual(client.lastPath, "v1/me/favorites")
        let query = client.lastQuery.reduce(into: [:]) { $0[$1.name] = $1.value }
        XCTAssertEqual(query["ids[songs]"], "1")
        XCTAssertEqual(query["ids[albums]"], "2")
    }

    func testAddFavoritesSupportsCsvAndResourceType() async throws {
        let client = StubClient()
        client.userToken = "user"
        let runner = ToolRunner(configPath: nil, beautify: false, client: client, stdout: { _ in }, stderr: { _ in })
        try await runner.run(toolName: "add_favorites", arguments: [
            "ids": .string("5,6"),
            "resourceType": .string("stations"),
            "l": .string("es")
        ])

        XCTAssertEqual(client.lastPath, "v1/me/favorites")
        let query = client.lastQuery.reduce(into: [:]) { $0[$1.name] = $1.value }
        XCTAssertEqual(query["ids[stations]"], "5,6")
        XCTAssertEqual(query["l"], "es")
    }

    func testSetRatingBuildsPathAndBody() async throws {
        let client = StubClient()
        client.userToken = "user"
        let runner = ToolRunner(configPath: nil, beautify: false, client: client, stdout: { _ in }, stderr: { _ in })
        try await runner.run(toolName: "set_rating", arguments: [
            "resourceType": .string("songs"),
            "id": .string("1"),
            "value": .int(1)
        ])

        XCTAssertEqual(client.lastMethod, "PUT")
        XCTAssertEqual(client.lastPath, "v1/me/ratings/songs/1")
        let body = try XCTUnwrap(client.lastBody)
        let json = try JSONSerialization.jsonObject(with: body) as? [String: Any]
        let attrs = json?["attributes"] as? [String: Any]
        XCTAssertEqual(attrs?["value"] as? Int, 1)
    }

    func testDeleteRatingBuildsPath() async throws {
        let client = StubClient()
        client.userToken = "user"
        let runner = ToolRunner(configPath: nil, beautify: false, client: client, stdout: { _ in }, stderr: { _ in })
        try await runner.run(toolName: "delete_rating", arguments: [
            "resourceType": .string("albums"),
            "id": .string("2")
        ])

        XCTAssertEqual(client.lastMethod, "DELETE")
        XCTAssertEqual(client.lastPath, "v1/me/ratings/albums/2")
    }
}

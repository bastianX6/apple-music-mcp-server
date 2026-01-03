import XCTest
import Foundation
import MCP
@testable import AppleMusicMCPServer

final class PlaceholderTests: XCTestCase {
    func testBootstrapLoadsConfig() async throws {
        let fm = FileManager.default
        let tempDir = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try fm.createDirectory(at: tempDir, withIntermediateDirectories: true)
        let configPath = tempDir.appendingPathComponent("config.json").path
        var config = AppConfig()
        config.teamID = "team"
        config.musicKitKeyID = "kid"
        config.privateKey = "-----BEGIN PRIVATE KEY-----\nabc\n-----END PRIVATE KEY-----"
        config.userToken = "user"
        _ = try SetupHelper.persistConfig(config, configPath: configPath)

        let loaded = try await ConfigLoader(configPath: configPath).load()
        XCTAssertEqual(loaded.teamID, "team")
    }

    func testDeveloperTokenMissingCredentialsThrows() {
        let provider = DeveloperTokenProvider()
        let config = AppConfig()

        XCTAssertThrowsError(try provider.token(using: config)) { error in
            guard case AuthError.missingCredentials = error else {
                XCTFail("Expected missingCredentials, got \(error)")
                return
            }
        }
    }

    func testAppleMusicAPIErrorDecoding() throws {
        let payload = """
        {"errors":[{"id":"123","status":"404","code":"not-found","title":"Not Found","detail":"Resource not found"}]}
        """.data(using: .utf8)!

        let apiError = AppleMusicAPIError.from(data: payload)
        XCTAssertNotNil(apiError)
        XCTAssertEqual(apiError?.status, "404")
        XCTAssertEqual(apiError?.code, "not-found")
        XCTAssertEqual(apiError?.title, "Not Found")
        XCTAssertEqual(apiError?.detail, "Resource not found")
    }

    func testPrettyPrintedJSON() throws {
        let client = AppleMusicClient(developerToken: "dev", userToken: nil)
        let registry = ToolRegistry(client: client)
        let data = "{\"a\":1}".data(using: .utf8)!

        let formatted = registry.prettyPrintedJSON(data)
        XCTAssertNotNil(formatted)
        XCTAssertTrue(formatted?.contains("\n") == true)
    }

    func testLibraryArtistsRequiresUserToken() async throws {
        let client = AppleMusicClient(developerToken: "dev", userToken: nil)
        let registry = ToolRegistry(client: client)
        let params = CallTool.Parameters(name: "get_library_artists")

        let result = try await registry.handleGetLibraryArtists(params: params)
        XCTAssertEqual(result.isError, true)
        let message = result.content.compactMap { content -> String? in
            if case let .text(text) = content { return text }
            return nil
        }.joined(separator: "\n")
        XCTAssertTrue(message.contains("User token is missing"))
    }

    func testGetCuratorsRequiresIds() async throws {
        let client = AppleMusicClient(developerToken: "dev", userToken: nil)
        let registry = ToolRegistry(client: client)
        let params = CallTool.Parameters(name: "get_curators")

        let result = try await registry.handleGetCurators(params: params)
        XCTAssertEqual(result.isError, true)
        let message = result.content.compactMap { content -> String? in
            if case let .text(text) = content { return text }
            return nil
        }.joined(separator: "\n")
        XCTAssertTrue(message.contains("Missing required argument 'ids'") )
    }

    func testGetActivitiesRequiresIds() async throws {
        let client = AppleMusicClient(developerToken: "dev", userToken: nil)
        let registry = ToolRegistry(client: client)
        let params = CallTool.Parameters(name: "get_activities")

        let result = try await registry.handleGetActivities(params: params)
        XCTAssertEqual(result.isError, true)
        let message = result.content.compactMap { content -> String? in
            if case let .text(text) = content { return text }
            return nil
        }.joined(separator: "\n")
        XCTAssertTrue(message.contains("Missing required argument 'ids'"))
    }

    func testCreatePlaylistRequiresUserToken() async throws {
        let client = AppleMusicClient(developerToken: "dev", userToken: nil)
        let registry = ToolRegistry(client: client)
        let params = CallTool.Parameters(name: "create_playlist", arguments: ["name": .string("Test")])

        let result = try await registry.handleCreatePlaylist(params: params)
        XCTAssertEqual(result.isError, true)
        let message = result.content.compactMap { content -> String? in
            if case let .text(text) = content { return text }
            return nil
        }.joined(separator: "\n")
        XCTAssertTrue(message.contains("User token is missing"))
    }

    func testAddLibrarySongsRequiresUserToken() async throws {
        let client = AppleMusicClient(developerToken: "dev", userToken: nil)
        let registry = ToolRegistry(client: client)
        let params = CallTool.Parameters(name: "add_library_songs", arguments: ["ids": .string("123")])

        let result = try await registry.handleAddLibrarySongs(params: params)
        XCTAssertEqual(result.isError, true)
        let message = result.content.compactMap { content -> String? in
            if case let .text(text) = content { return text }
            return nil
        }.joined(separator: "\n")
        XCTAssertTrue(message.contains("User token is missing"))
    }

    func testReplayReturnsNotAvailable() async throws {
        let client = AppleMusicClient(developerToken: "dev", userToken: "user")
        let registry = ToolRegistry(client: client)
        let params = CallTool.Parameters(name: "get_replay")

        let result = try await registry.handleGetReplay(params: params)
        XCTAssertEqual(result.isError, true)
        let message = result.content.compactMap { content -> String? in
            if case let .text(text) = content { return text }
            return nil
        }.joined(separator: "\n")
        XCTAssertTrue(message.contains("Replay data endpoint"))
    }

        func testPaginationNextOffsetParsesOffset() throws {
                let json = """
                {
                    "meta": {
                        "next": "https://api.music.apple.com/v1/me/library/songs?offset=25&limit=25"
                    }
                }
                """.data(using: .utf8)!

                let offset = PaginationParser.nextOffset(from: json)
                XCTAssertEqual(offset, 25)
        }
}

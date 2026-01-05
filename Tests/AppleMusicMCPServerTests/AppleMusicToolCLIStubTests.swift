import XCTest
import MCP
@testable import AppleMusicTool
@testable import AppleMusicCore

final class AppleMusicToolCLIStubTests: XCTestCase {
    final class StubClient: AppleMusicClientProtocol, @unchecked Sendable {
        var userToken: String? = nil
        var lastPath: String?
        var lastQuery: [URLQueryItem] = []
        var response: Data = Data("{\"ok\":true}".utf8)

        func get(path: String, queryItems: [URLQueryItem]) async throws -> Data {
            lastPath = path
            lastQuery = queryItems
            if path == "v1/me/storefront" { return Data("{\"data\":[{\"id\":\"us\"}]}".utf8) }
            return response
        }
        func post(path: String, queryItems: [URLQueryItem], body: Data?) async throws -> Data { response }
        func put(path: String, queryItems: [URLQueryItem], body: Data?) async throws -> Data { response }
        func delete(path: String, queryItems: [URLQueryItem]) async throws -> Data { response }
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
}

import XCTest

final class DocumentationTests: XCTestCase {
    private func repoRootURL() -> URL {
        var url = URL(fileURLWithPath: #filePath)
        url.deleteLastPathComponent() // DocumentationTests.swift
        url.deleteLastPathComponent() // AppleMusicMCPServerTests
        url.deleteLastPathComponent() // Tests
        return url
    }

    private func readFile(_ relativePath: String) throws -> String {
        let url = repoRootURL().appendingPathComponent(relativePath)
        return try String(contentsOf: url, encoding: .utf8)
    }

    func testHybridToolSpecHasExpectedSections() throws {
        let spec = try readFile("docs/hybrid_tool_spec.md")
        XCTAssertTrue(spec.contains("Hybrid Tool Specification"))
        XCTAssertTrue(spec.contains("Tool Selection Guidance"))
        XCTAssertTrue(spec.contains("search_catalog"))
        XCTAssertTrue(spec.contains("get_catalog_resources"))
        XCTAssertTrue(spec.contains("get_library_resources"))
    }

    func testEndpointMappingIsPopulated() throws {
        let mapping = try readFile("docs/hybrid_tool_endpoint_mapping.md")
        let rows = mapping
            .split(whereSeparator: \.isNewline)
            .filter { $0.hasPrefix("|") && !$0.contains("---") }
        XCTAssertGreaterThan(rows.count, 50)
        XCTAssertTrue(mapping.contains("v1/catalog/{storefront}/search"))
        XCTAssertTrue(mapping.contains("get_recommendation"))
    }

    func testSmokePromptsReferenceTools() throws {
        let prompts = try readFile("docs/hybrid_tool_smoke_prompts.md")
        XCTAssertTrue(prompts.contains("Call `search_catalog`"))
        XCTAssertTrue(prompts.contains("Call `get_catalog_resources`"))
        XCTAssertTrue(prompts.contains("Call `get_library_resources`"))
        XCTAssertTrue(prompts.contains("Call `set_rating`"))
    }
}

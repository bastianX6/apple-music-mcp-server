# Apple Music API Elements for Swift MCP Server

## Executive Summary
The Swift MCP server will expose 30 tools over MCP, backed by Apple Music REST endpoints. The API behavior matches the TypeScript implementation; language changes do not alter HTTP behavior. This document highlights the key data elements and Swift-specific considerations for building a macOS-only package.

## Core Elements (Swift Data Model Focus)
Define lightweight Swift structs to mirror Apple Music responses. Critical building blocks:
- `MusicItemID`: Typed identifier for catalog/library resources.
- `MusicItem` base struct: common attributes (id, type, href, attributes, relationships).
- `MusicItemCollection<T>`: Paginated collections with `meta` and `next` links.
- Request wrappers: `CatalogRequest` and `LibraryRequest` capturing storefront, ids, pagination, filters.
- Generic passthrough: `DataRequest` for unsupported/experimental endpoints.

### Critical Capabilities (13)
- Catalog search & suggestions
- Generic catalog resource fetch (songs, albums, artists, playlists)
- Generic data fetch (escape hatch)
- Library playlists, songs, albums
- Playlist creation and add-items
- Addable protocols: library-addable, playlist-addable (surface capability metadata)

### High-Potential Additions (Selected)
- Recommendations and recently played
- Charts (Top/City) and genres
- Stations (radio)
- Audio variants (Atmos/Lossless flags) in metadata
- Editorial notes and artwork color palettes

## Functional Categories
- **Search & Discovery**: catalog search, suggestions, charts, stations, activities, curators.
- **Personal Library**: playlists, songs, albums, artists, recently played.
- **Recommendations**: personalized mixes and heavy rotation.
- **Playlist Management**: create playlist, add items (library), add songs/albums (subject to 405 limitation).
- **Utility**: generic request passthrough for rapid feature unlocks.

## Swift-Specific Implementation Notes
- **Async HTTP**: Use `URLSession` with async/await; set `Accept` and `Content-Type` to `application/json`.
- **Headers**: `Authorization: Bearer <developerToken>` for catalog; `Music-User-Token: <userToken>` for library/personal endpoints.
- **Pagination**: Model `next` URLs and expose `offset`/`limit` inputs; return `meta.total` when present.
- **Error Modeling**: Decode Apple Music error payloads (`errors: [{id, status, code, title, detail}]`); propagate status and title back through MCP structured errors.
- **Date Handling**: Use ISO 8601 with fractional seconds for history timestamps.
- **Artwork Templates**: Keep `{w}`/`{h}` placeholders intact for clients to substitute.

## Platform & SDK Constraints
- Package must target **macOS only** (set `.macOS(.v13)` or newer in `Package.swift`).
- MCP transport: STDIO via `MCPServer` from the Swift SDK (https://github.com/modelcontextprotocol/swift-sdk).
- No reliance on iOS-only frameworks; restrict to Foundation, CryptoKit, and standard macOS APIs.

## Extensibility Strategy
- Use a `GenericRequestTool` that accepts method, path, params, and headers (validated) to cover new endpoints without changing the binary.
- Keep data models loosely typed: prefer `Decodable` wrappers with `RawJSON` storage for unmodeled attributes to avoid breakage when Apple adds fields.
- Introduce feature flags for endpoints with known gaps (replay data, radio shows, record labels) to keep UX explicit.

## Testing Considerations
- Unit tests for token generation (ES256), config loading, header injection, and pagination parsing.
- Integration tests with mocked Apple Music responses (using `URLProtocol` stubs or custom `URLSession` configuration).
- Golden file tests for representative catalog and library payloads to ensure decoding stability.

## Conclusion
The Swift MCP server reuses the same Apple Music surface area as the TypeScript version. Focus on:
- Robust auth handling (developer token generation; user token ingestion).
- Thin, predictable HTTP client with strong error propagation.
- Clear tool metadata for endpoints that are limited, regional, or unavailable.
- MacOS-only packaging and test targets aligned with the SPM layout.

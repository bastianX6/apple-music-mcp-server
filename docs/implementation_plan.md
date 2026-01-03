# Apple Music MCP Server Implementation Plan (Swift)

## Purpose
Blueprint for migrating the Apple Music MCP server from TypeScript to Swift as a macOS-only Swift Package. The server exposes MCP tools over STDIO using the MCP Swift SDK and mirrors the original tool surface.

## Goals
- Swift Package Manager project targeting macOS only.
- Same 30 tools (catalog + library + recommendations + management + utility) with identical behaviors and documented API limitations.
- Strong auth story: ES256 developer token generation; user token ingestion via helper flow.
- Clean package layout with mirrored test target structure.

## Non-Goals
- Shipping UI beyond the browser-based user-token helper page.
- Implementing production observability beyond structured logging.

## High-Level Architecture
- **Runtime**: Swift 5.9+ (SPM), macOS-only.
- **Transport**: MCP STDIO via `MCPServer` from https://github.com/modelcontextprotocol/swift-sdk.
- **Auth**: Developer token (ES256 JWT) generated in-process; user token supplied via setup helper or existing JS flow.
- **HTTP Client**: `URLSession` with async/await; thin wrapper for Apple Music API.
- **Tools Layer**: Domain-grouped tool registrations mapping to Apple Music endpoints; structured errors.
- **Config**: JSON file at `~/Library/Application Support/apple-music-mcp/config.json` (0600 perms); env vars only feed the setup command that writes the file.

## Package Layout (SPM)
```
apple-music-mcp-server/swift/
├─ Package.swift                      # .macOS(.v13) minimum
├─ Sources/
│  ├─ AppleMusicMCPServer/            # Executable target
│  │  ├─ main.swift                   # Entry: load config, init auth, start MCP server
│  │  ├─ Bootstrap/                   # wiring and dependency container
│  │  │  └─ ServerBootstrap.swift
│  │  ├─ Auth/
│  │  │  ├─ DeveloperTokenProvider.swift   # ES256 JWT signing, caching, renewal
│  │  │  └─ UserTokenProvider.swift        # Load/validate user token
│  │  ├─ Config/
│  │  │  └─ ConfigLoader.swift             # Merge env + file; ensure 0600
│  │  ├─ HTTP/
│  │  │  ├─ AppleMusicClient.swift         # URLSession wrapper; headers per endpoint
│  │  │  └─ Models/                        # Codable response/request models
│  │  ├─ Tools/
│  │  │  ├─ CatalogTools.swift             # search, songs, albums, artists, playlists, charts, genres, stations, curators, activities, music videos
│  │  │  ├─ LibraryTools.swift             # library playlists/songs/albums/artists, recently played, storefront
│  │  │  ├─ RecommendationTools.swift      # recommendations, heavy rotation, replay (documented 404)
│  │  │  ├─ ManagementTools.swift          # create playlist, add items; add songs/albums/favorites (405 limitations)
│  │  │  └─ UtilityTools.swift             # generic request passthrough
│  │  └─ Support/
│  │     ├─ Errors.swift
│  │     └─ Pagination.swift
│  └─ AppleMusicMCPSetup/            # Executable target for user-token acquisition
│     ├─ main.swift                   # Starts local server, opens browser
│     ├─ SetupServer.swift            # Lightweight HTTP server (127.0.0.1)
│     └─ Resources/SetupPage/         # Static HTML + MusicKit JS
└─ Tests/
   ├─ AppleMusicMCPServerTests/       # Mirrors Sources/AppleMusicMCPServer structure
   └─ AppleMusicMCPSetupTests/
```

## Authentication Flows
- **Developer Token**: ES256 JWT with Team ID (`iss`), MusicKit ID (`kid`), exp ~6 months. Cache in memory; renew when <30 days to expiry.
- **User Token**: Obtained via the integrated setup flow (CLI or browser) or reused from existing TypeScript flow. Stored at `~/Library/Application Support/apple-music-mcp/config.json` with 0600 permissions. Read-only usage in server.

## Configuration
- Env vars (`APPLE_MUSIC_TEAM_ID`, `APPLE_MUSIC_MUSICKIT_ID`, `APPLE_MUSIC_PRIVATE_KEY`) are consumed solely by the `setup` flow to produce the JSON file.
- Config file is the single source of truth at runtime and contains those keys plus the user token persisted by setup. Enforce user-only permissions.
- Clear error messages when required secrets are missing; server should not crash—surface actionable MCP errors instead.

## Tool Registration Guidelines
- Use Swift SDK tool definitions; set `destructiveHint=false`, `idempotentHint=true` for GET tools.
- Validate inputs (storefront default `us`, `offset`, `limit` caps, required IDs).
- For known-broken endpoints (405/404), keep tools but return explanatory errors referencing API limitations.
- Include structured content in responses (decoded models) and a pretty-printed JSON string for readability.

## HTTP Client Behavior
- Base URL: `https://api.music.apple.com`.
- Headers: developer token always for catalog; add `Music-User-Token` for library/personal endpoints.
- Retries: optional backoff for 429; do not retry 404/405.
- Pagination: expose `next` link when present; accept `offset`/`limit`.
- Error mapping: decode Apple Music error payloads; include `status`, `title`, `detail` in MCP errors.

## Testing Plan
- **Unit**: developer token signing/expiry checks; config loader file/permission validation; header injection; pagination parsing; error decoding.
- **Integration**: mock `URLSession` via custom `URLProtocol` to simulate Apple responses; verify tool outputs and MCP error propagation.
- **Fixture**: golden payloads for catalog and library resources to guard against decoding regressions.
- **Setup helper**: test local server callback handling and config file persistence.

## Build & Run
- Build: `swift build --product apple-music-mcp`
- Run server (stdio): `swift run apple-music-mcp`
- Run setup helper: `swift run AppleMusicMCPSetup`
- Tests: `swift test`

## Migration Phases
1) **Foundation**: Config loader, developer token signing, HTTP client with catalog GET tools.
2) **Library Read**: User token loading, library endpoints, storefront detection, recently played.
3) **Recommendations & Utility**: Recommendations, heavy rotation, generic request tool.
4) **Management & Polish**: Playlist creation/add-items, 405-limited tools with clear messaging, logging, caching, docs.

## Open Questions
- Should replay/radio-show/record-label tools be feature-flagged or excluded by default? (Current stance: include with explicit limitation messaging.)
- Preferred retry/backoff strategy for 429 responses (fixed vs exponential with jitter)?
- Should the setup helper share the config path with the TypeScript tool to allow cross-language reuse?

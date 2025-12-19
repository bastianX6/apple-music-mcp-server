# Apple Music API Known Limitations (Swift MCP Server)

This document records API constraints observed while testing the TypeScript MCP server and applies them to the forthcoming Swift implementation. The behavior is API-level, not language-specific; the Swift server will inherit the same limitations.

## Scope
- Target: Swift Package Manager command-line MCP server (macOS-only)
- SDK: https://github.com/modelcontextprotocol/swift-sdk
- Status source: Testing results from the TypeScript implementation (30 tools)

## Testing Results Snapshot
- Total tools: 30
- Tested: 30/30 (100%)
- Working: 24/30 (80%)
- Failed (API limitations): 6/30 (20%)
- Core features (library + catalog + user context + utility): 19/19 (100%)

### Category Breakdown
- Library Management: 5/5 ✅
- Catalog Tools: 9/9 ✅
- User Context: 4/4 ✅
- Utility: 1/1 ✅
- Write Operations: 2/5 ⚠️ (405)
- Recommendations: 1/2 ⚠️
- Editorial Content: 1/4 ⚠️

## Write Operations Returning 405
These endpoints are blocked by Apple Music; Swift transport and signing do not change the outcome.

1) Add Songs to Library — POST /v1/me/library/songs — 405 Method Not Allowed
2) Add Albums to Library — POST /v1/me/library/albums — 405 Method Not Allowed
3) Add to Favorites — POST /v1/me/favorites/{resourceType} — 405 Method Not Allowed

**Workarounds:** None. Keep tool descriptions explicit about the limitation; surface clear MCP errors.

## Editorial Content Restrictions
- Activities — GET /v1/catalog/{storefront}/activities — requires valid activity IDs; generic listing returns empty/400.
- Curators — GET /v1/catalog/{storefront}/curators — returns empty arrays for invalid IDs; requires valid curator IDs.
- Search Suggestions — GET /v1/catalog/{storefront}/search/suggestions — requires `kinds` (use `terms` default) to avoid empty responses.

## Non-Existent or Unavailable Endpoints
- Replay Data — GET /v1/me/replay — 404; not exposed publicly.
- Radio Shows — GET /v1/catalog/{storefront}/radio-shows/{id} — 404/resource type invalid; use stations instead.
- Record Labels — GET /v1/catalog/{storefront}/record-labels/{id} — labels exist as strings on albums; not queryable resources.

## Regional Variations
Content availability is storefront-dependent (activities, stations, music videos, some artists). The Swift server should:
- Fetch user storefront via /v1/me/storefront (user token) and default catalog calls to that value.
- Fail gracefully with region-specific messaging when data is absent.

## Verified Working Operations
- Library: playlists, songs, albums, recently played (pagination works).
- Catalog: songs, albums, artists, playlists, music videos, genres, charts, stations, search.
- Playlist management: create playlist; add items to playlist.
- Recommendations: personalized mixes; heavy rotation.
- User context: storefront; listening history.
- Utility: generic request passthrough.

## Implementation Notes for Swift
- These limitations must be reflected in tool metadata (`destructiveHint=false`, clear failure reasons) when registering MCP tools via the Swift SDK.
- Tests should assert the documented 405/404 behaviors to prevent regressions in error messaging and retry logic.
- Do not attempt client-side retries for 405/404 responses; they are structural, not transient.

## Production Guidance
1) Document required parameters (e.g., `kinds` for suggestions) directly in tool schemas.
2) Keep an updated registry of editorial IDs (activities, curators, stations) and rotate as Apple changes content.
3) Cache stable data (genres, storefront, charts) with short TTL to reduce rate limits.
4) For user-facing messaging, clarify that missing functionality is due to Apple Music API restrictions, not server defects.

## References
- Apple Music API docs: https://developer.apple.com/documentation/applemusicapi
- MusicKit JS docs (for user-token acquisition): https://developer.apple.com/documentation/musickitjs
- MCP Swift SDK: https://github.com/modelcontextprotocol/swift-sdk

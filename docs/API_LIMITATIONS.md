# Apple Music API Known Limitations (Swift MCP Server)

This document captures observed Apple Music API constraints and availability notes. It complements the full endpoint list in `docs/apple_music_api_endpoints.md` and the hybrid tool surface in `docs/hybrid_tool_spec.md`.

## Scope
- Target: Swift Package Manager MCP server (macOS and Linux toolchains)
- Source: Apple documentation + observed behavior from MCP tool testing
- Note: Limitations are API-level and apply regardless of language

## Write Operations Commonly Returning 405
These endpoints are documented but frequently return 405 for common resource types.

1) Add a resource to library — POST `/v1/me/library` — often 405 for songs/albums.
2) Add resource to favorites — POST `/v1/me/favorites` — often 405.

**Workarounds:** none known. Tools should surface explicit limitation errors and avoid retries.

## Replay Data Availability
- Replay is documented at GET `/v1/me/music-summaries`.
- Availability varies by account and region; responses may be empty or return 404.
- Fallback: use recent playback endpoints if replay data is unavailable.

## Editorial Content and IDs
- Activities and curators require valid IDs; generic listing is empty or 400.
- Search suggestions require `kinds` (use `terms` as default) to avoid empty responses.

## Record Labels and Radio Shows
- Record labels are documented but often return 404 or empty data in practice.
- Radio shows are represented via station relationships (`radio-show`) and can be missing in many storefronts.
- Treat these endpoints as best-effort and document their availability clearly.

## Ratings
- Ratings endpoints require a Music-User-Token.
- Values are limited to like/dislike.
- Behavior varies by account; validate in your target environment.

## Regional Variations
Content availability is storefront-dependent (activities, stations, music videos, some artists). The server should:
- Resolve the user storefront via `/v1/me/storefront` when available.
- Fail gracefully with region-specific messaging when data is absent.

## Verified Working Operations (as observed)
- Catalog: search, songs, albums, artists, playlists, music videos, charts, genres, stations.
- Library: playlists, songs, albums, artists, recently played.
- Playlist management: create playlist; add tracks.
- Recommendations: personalized mixes and heavy rotation.
- Utility: generic passthrough GET.

## Implementation Notes
- Reflect 404/405 limitations in tool descriptions and errors.
- Do not retry 404/405 responses.
- Keep validation for required params to avoid silent empty responses.

## References
- Apple Music API docs: https://developer.apple.com/documentation/applemusicapi
- MusicKit JS docs (user-token acquisition): https://developer.apple.com/documentation/musickitjs
- MCP Swift SDK: https://github.com/modelcontextprotocol/swift-sdk

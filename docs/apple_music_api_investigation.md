# Apple Music API Investigation (Hybrid Tool Surface)

## Executive Summary
The Apple Music API exposes a large, structured REST surface. This repo is moving to a hybrid MCP tool design: intent-based tools for common workflows plus a small set of generic tools that cover relationships, views, and typed-id queries. The full endpoint list lives in `docs/apple_music_api_endpoints.md`.

## Core Findings
- The API is heavily patterned by resource type, relationship, and view endpoints.
- Catalog endpoints are storefront-scoped; user endpoints are under `/v1/me` and require a Music-User-Token.
- Optional parameters like `include`, `extend`, `l`, `limit`, `offset`, and `views` appear across many endpoints.

## Tool Strategy
- **Intent tools** for search, charts, catalog lookups, library lists, recently played, recommendations, and playlist management.
- **Generic tools** to cover:
  - Catalog resources by type/ids
  - Catalog relationships (`/{relationship}`) and views (`/view/{view}`)
  - Library resources and relationships
  - Multi-type typed-id fetches for catalog/library
- **Fallback**: `generic_get` remains in the code but is disabled unless a future gap requires it.

See `docs/hybrid_tool_spec.md` for the proposed tool surface and `docs/hybrid_tool_endpoint_mapping.md` for full coverage.

## Data Modeling Notes
- Use lightweight resource wrappers (`id`, `type`, `href`, `attributes`, `relationships`).
- Preserve raw JSON for unmodeled attributes to avoid breakage as Apple adds fields.
- Keep artwork templates with `{w}`/`{h}` placeholders intact.

## Known Constraints
- Add-to-library and favorites endpoints often return 405.
- Replay data (`/v1/me/music-summaries`) may be unavailable depending on account/region.
- Editorial resources (activities/curators/record labels/radio shows) require valid IDs and are often storefront-dependent.

## References
- Apple Music API docs: https://developer.apple.com/documentation/applemusicapi
- Endpoint list: `docs/apple_music_api_endpoints.md`
- Hybrid tools: `docs/hybrid_tool_spec.md`

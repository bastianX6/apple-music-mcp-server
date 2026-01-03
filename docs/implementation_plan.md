# Apple Music MCP Server Implementation Plan (Hybrid Tools)

## Purpose
Implement the hybrid MCP tool surface that is LLM-friendly while covering the full Apple Music API endpoint set documented in `docs/apple_music_api_endpoints.md`.

## Goals
- Maintain stable, intent-based tools for common workflows.
- Add generic tools for relationships, views, and typed-id queries.
- Cover all documented Apple Music API endpoints via the mapping in `docs/hybrid_tool_endpoint_mapping.md`.
- Expand HTTP client support to PUT/DELETE for ratings.

## Non-Goals
- UI beyond the existing setup flow.
- Non-Apple Music APIs.

## Architecture Snapshot
- **Runtime**: Swift Package Manager executable.
- **Transport**: MCP STDIO (Swift SDK).
- **Auth**: Developer token + Music-User-Token from config file.
- **HTTP Client**: URLSession async/await; add PUT/DELETE support.
- **Tools**: Intent-based + generic tools (see `docs/hybrid_tool_spec.md`).

## Phases
- **Phase 1 (Read tools):**
  - Add missing catalog discovery tools (search hints).
  - Add generic catalog/library tools for resources, relationships, views, and typed-id queries.
  - Add library search and recently added.
- **Phase 2 (Write tools):**
  - Add playlist folders, add-library-resources, favorites.
  - Add ratings tools (PUT/DELETE).
- **Phase 3 (Docs + tests):**
  - Align README and limitation docs.
  - Add LLM smoke prompts (`docs/hybrid_tool_smoke_prompts.md`).

## Risks
- 405 responses for add-to-library/favorites.
- Replay data availability (`/v1/me/music-summaries`).
- Storefront-dependent resources (stations/activities/record labels).

## References
- Hybrid migration plan: `docs/hybrid_tool_migration_plan.md`
- Tool spec: `docs/hybrid_tool_spec.md`
- Endpoint mapping: `docs/hybrid_tool_endpoint_mapping.md`

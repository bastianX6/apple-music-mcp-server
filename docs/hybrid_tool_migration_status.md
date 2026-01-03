# Hybrid Tool Migration Status

This file tracks progress for the hybrid tool migration.

## Current Status
- Last updated: 2026-01-03
- Owner: repo maintainers

## Milestones

### Phase 0: Baseline and inventory
- [x] Full endpoint list in `docs/apple_music_api_endpoints.md`
- [x] Hybrid tool spec drafted in `docs/hybrid_tool_spec.md`
- [x] Tool surface review (LLM selection guidance added)
- [x] Endpoint-to-tool mapping in `docs/hybrid_tool_endpoint_mapping.md`
- [x] Documentation consistency update (README + limitations + investigation)
- [x] Doc consistency unit tests added

### Phase 1: Read-only tools
- [x] Implement catalog generic tools (resource, relationship, view, typed-id)
- [x] Implement library generic tools (resource, relationship, typed-id)
- [x] Implement missing discovery tools (search hints, library search, recently added)
- [x] Add unit tests for new read tools
- [x] Run tests with `swift test --disable-sandbox`

### Phase 2: Write tools and ratings
- [x] Implement playlist folders, add-library-resources, favorites
- [x] Implement ratings PUT/DELETE (and optional ratings GET)
- [x] Add unit tests for write/rating tools
- [x] Run tests with `swift test --disable-sandbox`

### Phase 3: Verification and docs
- [x] Update tool registry references in README if needed
- [x] Run smoke prompts from `docs/hybrid_tool_smoke_prompts.md` (published; run manually as needed)
- [x] Validate limitation messaging for 404/405

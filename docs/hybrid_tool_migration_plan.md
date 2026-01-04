# Hybrid Tool Migration Plan

## Goal
Move from a mostly one-tool-per-endpoint surface to a hybrid approach that is LLM-friendly while still covering all Apple Music API endpoints.

Hybrid approach:
- Keep explicit, intent-based tools for common user tasks.
- Add a small set of generic tools that cover the long tail (relationships, views, typed-id queries, and less common resources).
- Keep `generic_get` implemented for emergencies, but leave it disabled unless explicitly re-approved.

## Scope
- Add new tools to cover every endpoint listed in `docs/apple_music_api_endpoints.md`.
- Preserve current tools for backward compatibility.
- Expand the HTTP client to support PUT and DELETE for ratings.
- Add LLM smoke-test prompts for each tool class.

## Non-Goals
- Changing auth flows or config format.
- Adding UI or interactive setup features.
- Adding non-Apple Music endpoints.

## Phases

### Phase 0: Baseline and inventory
- Freeze current tools and document their behavior.
- Confirm the canonical endpoint list in `docs/apple_music_api_endpoints.md`.
- Identify missing coverage and known API limits (404/405).
 - Track progress in `docs/hybrid_tool_migration_status.md`.

Acceptance:
- Endpoint inventory is current and referenced by migration docs.

### Phase 1: Core hybrid tool set (read-only)
- Add generic catalog tools:
  - `get_catalog_resources`
  - `get_catalog_resource`
  - `get_catalog_relationship`
  - `get_catalog_view`
  - `get_catalog_multi_by_type_ids`
- Add generic library tools:
  - `get_library_resources`
  - `get_library_resource`
  - `get_library_relationship`
  - `get_library_multi_by_type_ids`
  - `library_search`
  - `get_library_recently_added`
- Add missing catalog search tool:
  - `get_search_hints`
- Add utility tool:
  - `get_best_language_tag`
- Keep intent-based tools (search, charts, recently played, recommendations, storefront).

Acceptance:
- All GET endpoints have a tool mapped in `docs/hybrid_tool_endpoint_mapping.md`.
- Existing tools still function as-is.

### Phase 2: Write tools and ratings
- Add write tools:
  - `create_playlist_folder`
  - `add_library_resources`
  - `add_favorites` (explicitly documents 405 risk)
- Add rating tools:
  - `set_rating` (PUT)
  - `delete_rating` (DELETE)
- Expand HTTP client:
  - Support PUT and DELETE methods, plus request body as needed.

Acceptance:
- All POST/PUT/DELETE endpoints have a tool mapped.
- Clear errors for 405/404 endpoints documented in `docs/API_LIMITATIONS.md`.

### Phase 3: Documentation and LLM guidance
- Publish tool specs and usage guidance.
- Publish explicit tool selection rules for LLMs.
- Add smoke-test prompts.

Acceptance:
- `docs/hybrid_tool_spec.md`, `docs/hybrid_tool_endpoint_mapping.md`, and `docs/hybrid_tool_smoke_prompts.md` are complete and consistent.

## Implementation Notes
- New tools should reuse the existing StorefrontResolver behavior: default to user storefront when available.
- Generic tools should accept optional query params (`include`, `extend`, `l`, `limit`, `offset`, `views`, `with`, and `filter[...]`) to avoid adding new tools for each optional feature.
- Avoid retry loops for 404/405.
- Maintain current tool names for compatibility; add new tools rather than renaming existing ones.

## Risks
- Ratings and favorites may return unexpected status codes depending on account capability.
- Replay data (`v1/me/music-summaries`) may not be available for all users.
- Record labels and radio show endpoints are documented but frequently return 404 in practice.

## Success Criteria
- Every endpoint in `docs/apple_music_api_endpoints.md` maps to at least one tool.
- LLMs can pick tools based on intent without needing full Apple Music API knowledge.
- Smoke prompts cover both success and known failure paths.

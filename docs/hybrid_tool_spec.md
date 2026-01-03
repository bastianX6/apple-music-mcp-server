# Hybrid Tool Specification

This document defines the proposed hybrid tool surface. It is designed for LLM-friendly selection while still covering all Apple Music API endpoints.

## Design Principles
- Prefer intent-based tools for common tasks.
- Use a small set of generic tools for relationships, views, and typed-id queries.
- Keep `generic_get` only as a fallback.

## Tool Selection Guidance (LLM-Friendly)
Choose the most specific tool that matches the user intent, in this order:
1) Intent tools (search, charts, catalog lookups, library lists, recommendations, playlist management).
2) Relationship and view tools (`get_catalog_relationship`, `get_catalog_view`, `get_library_relationship`).
3) Generic resource tools (`get_catalog_resources`, `get_catalog_resource`, `get_library_resources`, `get_library_resource`).
4) Typed-id multi fetch (`get_catalog_multi_by_type_ids`, `get_library_multi_by_type_ids`).
5) `generic_get` only when no tool is mapped.

## Auth Rules
- Catalog endpoints: Developer Token.
- User endpoints (`v1/me/...`): Developer Token plus Music-User-Token.

## Intent-Based Tools (LLM-friendly)
These tools are recommended for most user queries.

### Catalog discovery
- `search_catalog` (GET `/v1/catalog/{storefront}/search`)
  - Required: `term`
  - Optional: `types`, `limit`, `offset`, `storefront`, `with`
- `get_search_hints` (GET `/v1/catalog/{storefront}/search/hints`)
  - Required: `term`
  - Optional: `limit`, `storefront`, `l`
- `get_search_suggestions` (GET `/v1/catalog/{storefront}/search/suggestions`)
  - Required: `term`
  - Optional: `kinds`, `types`, `limit`, `storefront`, `l`
- `get_charts` (GET `/v1/catalog/{storefront}/charts`)
  - Optional: `types`, `chart`, `genre`, `limit`, `offset`, `storefront`, `with`, `l`
- `get_genres` (GET `/v1/catalog/{storefront}/genres`)
  - Optional: `storefront`, `l`
- `get_stations` (GET `/v1/catalog/{storefront}/stations`)
  - Required: `ids`
  - Optional: `storefront`, `l`, `include`, `extend`

### Catalog detail (common types)
- `get_catalog_songs` (GET `/v1/catalog/{storefront}/songs`)
  - Required: `ids`
  - Optional: `storefront`, `l`, `include`, `extend`
- `get_catalog_albums` (GET `/v1/catalog/{storefront}/albums`)
  - Required: `ids`
  - Optional: `storefront`, `l`, `include`, `extend`
- `get_catalog_artists` (GET `/v1/catalog/{storefront}/artists`)
  - Required: `ids`
  - Optional: `storefront`, `l`, `include`, `extend`
- `get_catalog_playlists` (GET `/v1/catalog/{storefront}/playlists`)
  - Required: `ids`
  - Optional: `storefront`, `l`, `include`, `extend`
- `get_music_videos` (GET `/v1/catalog/{storefront}/music-videos`)
  - Required: `ids`
  - Optional: `storefront`, `l`, `include`, `extend`
- `get_curators` (GET `/v1/catalog/{storefront}/curators`)
  - Required: `ids`
  - Optional: `storefront`, `l`, `include`, `extend`
- `get_activities` (GET `/v1/catalog/{storefront}/activities`)
  - Required: `ids`
  - Optional: `storefront`, `l`, `include`, `extend`

### User context and history
- `get_user_storefront` (GET `/v1/me/storefront`)
- `get_recently_played` (GET `/v1/me/recent/played`)
  - Optional: `types`, `limit`, `offset`, `l`, `include`, `extend`
- `get_recently_played_tracks` (GET `/v1/me/recent/played/tracks`)
  - Optional: `types`, `limit`, `offset`, `l`, `include`, `extend`
- `get_recently_played_stations` (GET `/v1/me/recent/radio-stations`)
  - Optional: `limit`, `offset`, `l`, `include`, `extend`
- `get_recommendations` (GET `/v1/me/recommendations`)
  - Optional: `ids`, `limit`, `l`, `include`, `extend`
- `get_recommendation` (GET `/v1/me/recommendations/{id}`)
  - Required: `id`
  - Optional: `l`, `include`, `extend`
- `get_recommendation_relationship` (GET `/v1/me/recommendations/{id}/{relationship}`)
  - Required: `id`, `relationship`
  - Optional: `limit`, `l`, `include`, `extend`
- `get_heavy_rotation` (GET `/v1/me/history/heavy-rotation`)
  - Optional: `limit`, `offset`, `l`, `include`, `extend`
- `get_replay_data` (GET `/v1/me/music-summaries`)
  - Required: `filter[year]`
  - Optional: `views`, `l`, `include`, `extend`

### Library convenience tools
- `get_library_playlists` (GET `/v1/me/library/playlists`)
  - Optional: `limit`, `offset`, `l`, `include`, `extend`
- `get_library_songs` (GET `/v1/me/library/songs`)
  - Optional: `limit`, `offset`, `l`, `include`, `extend`
- `get_library_albums` (GET `/v1/me/library/albums`)
  - Optional: `limit`, `offset`, `l`, `include`, `extend`
- `get_library_artists` (GET `/v1/me/library/artists`)
  - Optional: `limit`, `offset`, `l`, `include`, `extend`
- `library_search` (GET `/v1/me/library/search`)
  - Required: `term`, `types`
  - Optional: `limit`, `offset`, `l`
- `get_library_recently_added` (GET `/v1/me/library/recently-added`)
  - Optional: `l`

### Playlist management
- `create_playlist` (POST `/v1/me/library/playlists`)
  - Required: `name`
  - Optional: `description`, `tracks`, `parent` (folder id)
- `add_playlist_tracks` (POST `/v1/me/library/playlists/{id}/tracks`)
  - Required: `playlistId`, `trackIds`
- `create_playlist_folder` (POST `/v1/me/library/playlist-folders`)
  - Required: `name`

## Generic Coverage Tools
These tools cover relationships, views, and rarely used resources.

### Catalog
- `get_catalog_multi_by_type_ids` (GET `/v1/catalog/{storefront}`)
  - Required: `ids` object keyed by resource type (translated to `ids[resourceType]=...`).
- `get_catalog_resources` (GET `/v1/catalog/{storefront}/{type}`)
  - Required: `type`, `ids`
- `get_catalog_resource` (GET `/v1/catalog/{storefront}/{type}/{id}`)
  - Required: `type`, `id`
- `get_catalog_relationship` (GET `/v1/catalog/{storefront}/{type}/{id}/{relationship}`)
  - Required: `type`, `id`, `relationship`
- `get_catalog_view` (GET `/v1/catalog/{storefront}/{type}/{id}/view/{view}`)
  - Required: `type`, `id`, `view`

### Library
- `get_library_multi_by_type_ids` (GET `/v1/me/library`)
  - Required: `ids` object keyed by `library-<type>` (translated to `ids[library-<type>]=...`).
- `get_library_resources` (GET `/v1/me/library/{type}`)
  - Required: `type`, `ids`
- `get_library_resource` (GET `/v1/me/library/{type}/{id}`)
  - Required: `type`, `id`
- `get_library_relationship` (GET `/v1/me/library/{type}/{id}/{relationship}`)
  - Required: `type`, `id`, `relationship`

## Write Tools (Long Tail)
- `add_library_resources` (POST `/v1/me/library`)
  - Required: `ids` object keyed by resource type (translated to `ids[resourceType]=...`).
  - Note: Apple often returns 405 for songs/albums; document limitation.
- `add_favorites` (POST `/v1/me/favorites`)
  - Required: `ids`
  - Note: Often returns 405; document limitation.

## Ratings Tools
- `set_rating` (PUT `/v1/me/ratings/{resourceType}/{id}`)
  - Required: `resourceType`, `id`, `value` (like/dislike per Ratings API)
- `delete_rating` (DELETE `/v1/me/ratings/{resourceType}/{id}`)
  - Required: `resourceType`, `id`
  - Read-only ratings endpoints are covered via `generic_get` for now.

## Utility
- `get_best_language_tag` (GET `/v1/language/{storefront}/tag`)
  - Required: `acceptLanguage`, `storefront`
- `generic_get` (GET `/v1/{endpoint}`)
  - Used only when a new endpoint is not yet mapped.

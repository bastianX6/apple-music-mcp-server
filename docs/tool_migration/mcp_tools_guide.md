# MCP Tool Surface (Current) — Reference Guide

This document describes the **current tool surface exposed by the `apple-music-mcp` MCP server**.
It is intended as the source of truth for migrating the same capabilities to a standalone CLI.

## See also
- `docs/tool_migration/README.md:1` (entry point for all migration docs)
- `docs/tool_migration/apple_music_tool_cli_proposal.md:1` (kebab-case CLI proposal + output/error/logging contracts)
- `docs/tool_migration/implementation_checklist.md:1` (implementation checklist by subcommand/tool)
- `Sources/AppleMusicMCPServer/Tools/ToolRegistry+Tools.swift:1` (tool schemas: names, descriptions, required/optional inputs)
- `Sources/AppleMusicMCPServer/Tools/ToolRegistry+Register.swift:1` (tool dispatch mapping)
- `docs/hybrid_tool_spec.md:1` (hybrid tool rationale and coverage)
- `docs/hybrid_tool_endpoint_mapping.md:1` (Apple Music endpoints ↔ tool mapping)
- `docs/API_LIMITATIONS.md:1` (known Apple API limitations and best-effort behavior)
- `docs/configuration.md:1` and `docs/apple_music_api_auth_guide.md:1` (config + tokens)

## Important Notes
- The MCP server returns tool results as **text** (MCP `content: [.text(...)]`).
- On success, that text is usually a **pretty-printed JSON** string (the Apple Music API response body).
- On failures, the tool often returns a **plain text error message** (not the Apple Music API JSON error payload).
- `generic_get` exists in code but is **disabled by default** in the MCP server.

## Authentication Rules
- **Catalog endpoints** (`/v1/catalog/...`, `/v1/language/...`): require a **Developer Token**.
- **User endpoints** (`/v1/me/...`): require a **Developer Token + Music-User-Token**.

## Storefront Resolution
Many catalog tools accept a `storefront` parameter.
When a **Music-User-Token is available**, the server attempts to resolve the user storefront and **ignores any provided storefront override**.
When no user token is available, the server defaults to `us` unless a `storefront` is provided.

## Summary Table

| Tool | Method | Apple Music API Path | Auth | Notes |
| --- | --- | --- | --- | --- |
| `generic_get` (disabled) | GET | `{path}` | Dev token (catalog) / + user token (me) | Disabled in MCP server; present for emergency coverage |
| `get_user_storefront` | GET | `/v1/me/storefront` | Dev + user token | Returns user storefront JSON |
| `search_catalog` | GET | `/v1/catalog/{storefront}/search` | Dev token | Storefront auto-resolved when user token exists |
| `get_search_hints` | GET | `/v1/catalog/{storefront}/search/hints` | Dev token | Storefront auto-resolved when user token exists |
| `get_search_suggestions` | GET | `/v1/catalog/{storefront}/search/suggestions` | Dev token | Storefront auto-resolved when user token exists |
| `get_charts` | GET | `/v1/catalog/{storefront}/charts` | Dev token | Storefront auto-resolved when user token exists |
| `get_genres` | GET | `/v1/catalog/{storefront}/genres` | Dev token | Storefront auto-resolved when user token exists |
| `get_stations` | GET | `/v1/catalog/{storefront}/stations` | Dev token | Requires `ids` |
| `get_catalog_songs` | GET | `/v1/catalog/{storefront}/songs` | Dev token | Requires `ids` |
| `get_catalog_albums` | GET | `/v1/catalog/{storefront}/albums` | Dev token | Requires `ids` |
| `get_catalog_artists` | GET | `/v1/catalog/{storefront}/artists` | Dev token | Requires `ids` |
| `get_catalog_playlists` | GET | `/v1/catalog/{storefront}/playlists` | Dev token | Requires `ids` |
| `get_music_videos` | GET | `/v1/catalog/{storefront}/music-videos` | Dev token | Requires `ids` |
| `get_curators` | GET | `/v1/catalog/{storefront}/curators` | Dev token | Requires `ids` |
| `get_activities` | GET | `/v1/catalog/{storefront}/activities` | Dev token | Requires `ids` |
| `get_catalog_resources` | GET | `/v1/catalog/{storefront}/{type}` | Dev token | Requires `type` + `ids` |
| `get_catalog_resource` | GET | `/v1/catalog/{storefront}/{type}/{id}` | Dev token | Requires `type` + `id` |
| `get_catalog_relationship` | GET | `/v1/catalog/{storefront}/{type}/{id}/{relationship}` | Dev token | Requires `type` + `id` + `relationship` |
| `get_catalog_view` | GET | `/v1/catalog/{storefront}/{type}/{id}/view/{view}` | Dev token | Requires `type` + `id` + `view` |
| `get_catalog_multi_by_type_ids` | GET | `/v1/catalog/{storefront}` | Dev token | Requires `ids` object (typed keys) |
| `get_best_language_tag` | GET | `/v1/language/{storefront}/tag` | Dev token | Requires `acceptLanguage` |
| `get_record_labels` | — | — | — | Informative error; no request sent |
| `get_radio_shows` | — | — | — | Informative error; no request sent |
| `get_library_playlists` | GET | `/v1/me/library/playlists` | Dev + user token | Pagination via `limit`/`offset` |
| `get_library_songs` | GET | `/v1/me/library/songs` | Dev + user token | Pagination via `limit`/`offset` |
| `get_library_albums` | GET | `/v1/me/library/albums` | Dev + user token | Pagination via `limit`/`offset` |
| `get_library_artists` | GET | `/v1/me/library/artists` | Dev + user token | Pagination via `limit`/`offset` |
| `get_library_resources` | GET | `/v1/me/library/{type}` | Dev + user token | Requires `type`; optional `ids` |
| `get_library_resource` | GET | `/v1/me/library/{type}/{id}` | Dev + user token | Requires `type` + `id` |
| `get_library_relationship` | GET | `/v1/me/library/{type}/{id}/{relationship}` | Dev + user token | Requires `type` + `id` + `relationship` |
| `get_library_multi_by_type_ids` | GET | `/v1/me/library` | Dev + user token | Requires `ids` object (typed keys) |
| `library_search` | GET | `/v1/me/library/search` | Dev + user token | Requires `term` + `types` |
| `get_library_recently_added` | GET | `/v1/me/library/recently-added` | Dev + user token | Optional `l` |
| `get_recently_played` | GET | `/v1/me/recent/played` | Dev + user token | Optional `types`, pagination |
| `get_recently_played_tracks` | GET | `/v1/me/recent/played/tracks` | Dev + user token | Optional `types`, pagination |
| `get_recently_played_stations` | GET | `/v1/me/recent/radio-stations` | Dev + user token | Pagination |
| `get_recommendations` | GET | `/v1/me/recommendations` | Dev + user token | Optional `ids`, capped `limit` |
| `get_recommendation` | GET | `/v1/me/recommendations/{id}` | Dev + user token | Requires `id` |
| `get_recommendation_relationship` | GET | `/v1/me/recommendations/{id}/{relationship}` | Dev + user token | Requires `id` + `relationship` |
| `get_heavy_rotation` | GET | `/v1/me/history/heavy-rotation` | Dev + user token | Pagination |
| `get_replay_data` | GET | `/v1/me/music-summaries` | Dev + user token | Requires `filter[year]=latest` |
| `get_replay` | — | — | — | Informative error; no request sent |
| `create_playlist` | POST | `/v1/me/library/playlists` | Dev + user token | Requires `name`; optional `tracks`, `parent` |
| `add_playlist_tracks` | POST | `/v1/me/library/playlists/{playlistId}/tracks` | Dev + user token | Requires `playlistId`, `trackIds` |
| `create_playlist_folder` | POST | `/v1/me/library/playlist-folders` | Dev + user token | Requires `name` |
| `add_library_resources` | POST | `/v1/me/library` | Dev + user token | Requires `ids` (object) or `resourceType` fallback |
| `add_library_songs` | POST | `/v1/me/library` | Dev + user token | Requires `ids` (songs). Often 405 |
| `add_library_albums` | POST | `/v1/me/library` | Dev + user token | Requires `ids` (albums). Often 405 |
| `add_favorites` | POST | `/v1/me/favorites` | Dev + user token | Requires `ids`; often 405 |
| `set_rating` | PUT | `/v1/me/ratings/{resourceType}/{id}` | Dev + user token | Requires `resourceType`, `id`, `value` |
| `delete_rating` | DELETE | `/v1/me/ratings/{resourceType}/{id}` | Dev + user token | Requires `resourceType`, `id` |

---

## Tool Details

### `generic_get` (disabled in MCP server)
**Method/Path:** GET `{path}`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `path` | Yes | string | Relative API path (e.g., `v1/catalog/us/search?term=ray`) |

**Response**
- Success: Pretty-printed Apple Music API JSON body.
- Error: Plain text `"Request failed: ..."` or `"Missing required argument 'path'."`.

### `get_user_storefront`
**Method/Path:** GET `/v1/me/storefront`

**Parameters:** none

**Response**
- Success: Pretty-printed JSON storefront payload.
- Error: Plain text if `Music-User-Token` is missing, or request failure message.

### `search_catalog`
**Method/Path:** GET `/v1/catalog/{storefront}/search`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `term` | Yes | string | Search term (URL-encoded internally) |
| `types` | No | string | Comma-separated resource types (default: `songs,albums,artists,playlists`) |
| `limit` | No | integer | 1–25 (default: 10) |
| `offset` | No | integer | ≥ 0 (default: 0) |
| `storefront` | No | string | Storefront code (default: `us`; ignored when user token resolves storefront) |
| `with` | No | string | Additional resource types to include |
| `l` | No | string | Language tag override |

**Response**
- Success: Pretty-printed Apple Music API JSON body.
- Error: Plain text message.

### `get_search_hints`
**Method/Path:** GET `/v1/catalog/{storefront}/search/hints`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `term` | Yes | string | Partial search term (URL-encoded internally) |
| `limit` | No | integer | 1–25 |
| `storefront` | No | string | Storefront code (default: `us`; ignored when user token resolves storefront) |
| `l` | No | string | Language tag override |

### `get_search_suggestions`
**Method/Path:** GET `/v1/catalog/{storefront}/search/suggestions`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `term` | Yes | string | Partial search term (URL-encoded internally) |
| `kinds` | No | string | Default: `terms`. Allowed (per tool help): `terms, activities, albums, artists, curators, music-videos, playlists, record-labels, songs, stations` |
| `types` | No | string | Comma-separated resource types to include |
| `limit` | No | integer | 1–25 |
| `storefront` | No | string | Storefront code (default: `us`; ignored when user token resolves storefront) |
| `l` | No | string | Language tag override |

### `get_charts`
**Method/Path:** GET `/v1/catalog/{storefront}/charts`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `types` | No | string | Default: `songs,albums,playlists` |
| `chart` | No | string | Default: `most-played` |
| `genre` | No | string | Genre ID |
| `limit` | No | integer | 1–50 (default: 10) |
| `offset` | No | integer | ≥ 0 (default: 0) |
| `with` | No | string | Additional resource types to include |
| `storefront` | No | string | Storefront code (default: `us`; ignored when user token resolves storefront) |
| `l` | No | string | Language tag override |

### `get_genres`
**Method/Path:** GET `/v1/catalog/{storefront}/genres`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `storefront` | No | string | Storefront code (default: `us`; ignored when user token resolves storefront) |
| `l` | No | string | Language tag override |

### `get_stations`
**Method/Path:** GET `/v1/catalog/{storefront}/stations`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `ids` | Yes | string | Comma-separated station IDs (e.g., `ra.978194965`) |
| `storefront` | No | string | Storefront code (default: `us`; ignored when user token resolves storefront) |
| `include` | No | string | Relationship data to include |
| `extend` | No | string | Extended attributes to include |
| `l` | No | string | Language tag override |

### `get_catalog_songs`
**Method/Path:** GET `/v1/catalog/{storefront}/songs`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `ids` | Yes | string | Comma-separated song IDs |
| `limit` | No | integer | 1–25 |
| `storefront` | No | string | Storefront code (default: `us`; ignored when user token resolves storefront) |
| `include` | No | string | Relationship data to include |
| `extend` | No | string | Extended attributes to include |
| `l` | No | string | Language tag override |

### `get_catalog_albums`
**Method/Path:** GET `/v1/catalog/{storefront}/albums`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `ids` | Yes | string | Comma-separated album IDs |
| `limit` | No | integer | 1–25 |
| `storefront` | No | string | Storefront code (default: `us`; ignored when user token resolves storefront) |
| `include` | No | string | Relationship data to include |
| `extend` | No | string | Extended attributes to include |
| `l` | No | string | Language tag override |

### `get_catalog_artists`
**Method/Path:** GET `/v1/catalog/{storefront}/artists`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `ids` | Yes | string | Comma-separated artist IDs |
| `storefront` | No | string | Storefront code (default: `us`; ignored when user token resolves storefront) |
| `include` | No | string | Relationship data to include |
| `extend` | No | string | Extended attributes to include |
| `l` | No | string | Language tag override |

### `get_catalog_playlists`
**Method/Path:** GET `/v1/catalog/{storefront}/playlists`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `ids` | Yes | string | Comma-separated playlist IDs |
| `storefront` | No | string | Storefront code (default: `us`; ignored when user token resolves storefront) |
| `include` | No | string | Relationship data to include |
| `extend` | No | string | Extended attributes to include |
| `l` | No | string | Language tag override |

### `get_music_videos`
**Method/Path:** GET `/v1/catalog/{storefront}/music-videos`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `ids` | Yes | string | Comma-separated music video IDs |
| `storefront` | No | string | Storefront code (default: `us`; ignored when user token resolves storefront) |
| `include` | No | string | Relationship data to include |
| `extend` | No | string | Extended attributes to include |
| `l` | No | string | Language tag override |

### `get_curators`
**Method/Path:** GET `/v1/catalog/{storefront}/curators`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `ids` | Yes | string | Comma-separated curator IDs |
| `storefront` | No | string | Storefront code (default: `us`; ignored when user token resolves storefront) |
| `include` | No | string | Relationship data to include |
| `extend` | No | string | Extended attributes to include |
| `l` | No | string | Language tag override |

### `get_activities`
**Method/Path:** GET `/v1/catalog/{storefront}/activities`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `ids` | Yes | string | Comma-separated activity IDs |
| `storefront` | No | string | Storefront code (default: `us`; ignored when user token resolves storefront) |
| `include` | No | string | Relationship data to include |
| `extend` | No | string | Extended attributes to include |
| `l` | No | string | Language tag override |

### `get_catalog_resources`
**Method/Path:** GET `/v1/catalog/{storefront}/{type}`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `type` | Yes | string | Resource type (tool help suggests: `songs, albums, artists, playlists, curators, stations, music-videos, activities, genres, record-labels`) |
| `ids` | Yes | string | Comma-separated IDs |
| `storefront` | No | string | Storefront code (default: `us`; ignored when user token resolves storefront) |
| `include` | No | string | Relationship data to include |
| `extend` | No | string | Extended attributes to include |
| `l` | No | string | Language tag override |

### `get_catalog_resource`
**Method/Path:** GET `/v1/catalog/{storefront}/{type}/{id}`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `type` | Yes | string | Resource type |
| `id` | Yes | string | Resource ID |
| `storefront` | No | string | Storefront code (default: `us`; ignored when user token resolves storefront) |
| `include` | No | string | Relationship data to include |
| `extend` | No | string | Extended attributes to include |
| `l` | No | string | Language tag override |

### `get_catalog_relationship`
**Method/Path:** GET `/v1/catalog/{storefront}/{type}/{id}/{relationship}`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `type` | Yes | string | Resource type |
| `id` | Yes | string | Resource ID |
| `relationship` | Yes | string | Relationship name (Apple Music API relationship name) |
| `limit` | No | integer | Passed through to API |
| `offset` | No | integer | Passed through to API |
| `storefront` | No | string | Storefront code (default: `us`; ignored when user token resolves storefront) |
| `include` | No | string | Relationship data to include |
| `extend` | No | string | Extended attributes to include |
| `l` | No | string | Language tag override |

### `get_catalog_view`
**Method/Path:** GET `/v1/catalog/{storefront}/{type}/{id}/view/{view}`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `type` | Yes | string | Resource type |
| `id` | Yes | string | Resource ID |
| `view` | Yes | string | View name (Apple Music API view name) |
| `limit` | No | integer | Passed through to API |
| `offset` | No | integer | Passed through to API |
| `storefront` | No | string | Storefront code (default: `us`; ignored when user token resolves storefront) |
| `include` | No | string | Relationship data to include |
| `extend` | No | string | Extended attributes to include |
| `l` | No | string | Language tag override |

### `get_catalog_multi_by_type_ids`
**Method/Path:** GET `/v1/catalog/{storefront}` (with typed `ids[...]` query parameters)

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `ids` | Yes | object | Object keyed by resource type (allowed keys per tool help: `songs, albums, artists, playlists, curators, stations, music-videos, activities, genres, record-labels`) |
| `storefront` | No | string | Storefront code (default: `us`; ignored when user token resolves storefront) |
| `include` | No | string | Relationship data to include |
| `extend` | No | string | Extended attributes to include |
| `l` | No | string | Language tag override |

### `get_best_language_tag`
**Method/Path:** GET `/v1/language/{storefront}/tag`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `acceptLanguage` | Yes | string | Preferred language tag (e.g., `es-ES`) |
| `storefront` | No | string | Storefront code (default: `us`; ignored when user token resolves storefront) |
| `l` | No | string | Language tag override |

### `get_record_labels`
**Behavior:** Informative error; **no request is sent**.

### `get_radio_shows`
**Behavior:** Informative error; **no request is sent**.

### `get_library_playlists`
**Method/Path:** GET `/v1/me/library/playlists`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `limit` | No | integer | 1–100 (default: 25) |
| `offset` | No | integer | ≥ 0 (default: 0) |
| `include` | No | string | Relationship data to include |
| `extend` | No | string | Extended attributes to include |
| `l` | No | string | Language tag override |

### `get_library_songs`
**Method/Path:** GET `/v1/me/library/songs`

**Parameters:** same as `get_library_playlists`

### `get_library_albums`
**Method/Path:** GET `/v1/me/library/albums`

**Parameters:** same as `get_library_playlists`

### `get_library_artists`
**Method/Path:** GET `/v1/me/library/artists`

**Parameters:** same as `get_library_playlists`

### `get_library_resources`
**Method/Path:** GET `/v1/me/library/{type}`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `type` | Yes | string | Library resource type (tool help suggests: `songs, albums, artists, playlists, playlist-folders, music-videos`) |
| `ids` | No | string | Comma-separated IDs |
| `limit` | No | integer | Passed through to API |
| `offset` | No | integer | Passed through to API |
| `filter[identity]` | No | string | Passed through to API |
| `include` | No | string | Relationship data to include |
| `extend` | No | string | Extended attributes to include |
| `l` | No | string | Language tag override |

### `get_library_resource`
**Method/Path:** GET `/v1/me/library/{type}/{id}`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `type` | Yes | string | Library resource type |
| `id` | Yes | string | Library resource ID |
| `include` | No | string | Relationship data to include |
| `extend` | No | string | Extended attributes to include |
| `l` | No | string | Language tag override |

### `get_library_relationship`
**Method/Path:** GET `/v1/me/library/{type}/{id}/{relationship}`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `type` | Yes | string | Library resource type |
| `id` | Yes | string | Library resource ID |
| `relationship` | Yes | string | Relationship name |
| `limit` | No | integer | Passed through to API |
| `offset` | No | integer | Passed through to API |
| `include` | No | string | Relationship data to include |
| `extend` | No | string | Extended attributes to include |
| `l` | No | string | Language tag override |

### `get_library_multi_by_type_ids`
**Method/Path:** GET `/v1/me/library` (with typed `ids[...]` query parameters)

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `ids` | Yes | object | Object keyed by library resource types (translated to `ids[<key>]`) |
| `include` | No | string | Relationship data to include |
| `extend` | No | string | Extended attributes to include |
| `l` | No | string | Language tag override |

### `library_search`
**Method/Path:** GET `/v1/me/library/search`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `term` | Yes | string | Search term (URL-encoded internally) |
| `types` | Yes | string | Comma-separated library resource types |
| `limit` | No | integer | 1–25 (default: 10) |
| `offset` | No | integer | ≥ 0 (default: 0) |
| `l` | No | string | Language tag override |

### `get_library_recently_added`
**Method/Path:** GET `/v1/me/library/recently-added`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `l` | No | string | Language tag override |

### `get_recently_played`
**Method/Path:** GET `/v1/me/recent/played`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `types` | No | string | Filter types |
| `limit` | No | integer | 1–100 (default: 10) |
| `offset` | No | integer | ≥ 0 (default: 0) |
| `include` | No | string | Relationship data to include |
| `extend` | No | string | Extended attributes to include |
| `l` | No | string | Language tag override |

### `get_recently_played_tracks`
**Method/Path:** GET `/v1/me/recent/played/tracks`

**Parameters:** same as `get_recently_played`

### `get_recently_played_stations`
**Method/Path:** GET `/v1/me/recent/radio-stations`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `limit` | No | integer | 1–100 (default: 10) |
| `offset` | No | integer | ≥ 0 (default: 0) |
| `include` | No | string | Relationship data to include |
| `extend` | No | string | Extended attributes to include |
| `l` | No | string | Language tag override |

### `get_recommendations`
**Method/Path:** GET `/v1/me/recommendations`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `ids` | No | string | Comma-separated recommendation IDs |
| `limit` | No | integer | 1–50 (default: 10) |
| `include` | No | string | Relationship data to include |
| `extend` | No | string | Extended attributes to include |
| `l` | No | string | Language tag override |

### `get_recommendation`
**Method/Path:** GET `/v1/me/recommendations/{id}`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `id` | Yes | string | Recommendation ID |
| `include` | No | string | Relationship data to include |
| `extend` | No | string | Extended attributes to include |
| `l` | No | string | Language tag override |

### `get_recommendation_relationship`
**Method/Path:** GET `/v1/me/recommendations/{id}/{relationship}`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `id` | Yes | string | Recommendation ID |
| `relationship` | Yes | string | Relationship name |
| `limit` | No | integer | Passed through to API |
| `offset` | No | integer | Passed through to API |
| `include` | No | string | Relationship data to include |
| `extend` | No | string | Extended attributes to include |
| `l` | No | string | Language tag override |

### `get_heavy_rotation`
**Method/Path:** GET `/v1/me/history/heavy-rotation`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `limit` | No | integer | 1–100 (default: 10) |
| `offset` | No | integer | ≥ 0 (default: 0) |
| `include` | No | string | Relationship data to include |
| `extend` | No | string | Extended attributes to include |
| `l` | No | string | Language tag override |

### `get_replay_data`
**Method/Path:** GET `/v1/me/music-summaries`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `filter[year]` | Yes | string | Must be `latest` (validated) |
| `views` | No | string | Comma-separated: `top-artists, top-albums, top-songs` (validated when provided) |
| `include` | No | string | Relationship data to include |
| `extend` | No | string | Extended attributes to include |
| `l` | No | string | Language tag override |

### `get_replay`
**Behavior:** Informative error; **no request is sent**.

### `create_playlist`
**Method/Path:** POST `/v1/me/library/playlists`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `name` | Yes | string | Playlist name |
| `description` | No | string | Playlist description |
| `tracks` | No | string | Comma-separated track IDs to add (catalog song IDs) |
| `parent` | No | string | Parent folder ID (`library-playlist-folders`) |

### `add_playlist_tracks`
**Method/Path:** POST `/v1/me/library/playlists/{playlistId}/tracks`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `playlistId` | Yes | string | Library playlist ID |
| `trackIds` | Yes | string | Comma-separated track IDs (sent as `type: songs`) |

### `create_playlist_folder`
**Method/Path:** POST `/v1/me/library/playlist-folders`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `name` | Yes | string | Folder name |

### `add_library_resources`
**Method/Path:** POST `/v1/me/library`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `ids` | Yes | object/string | Object keyed by resource type (allowed keys: `songs, albums, artists, music-videos, playlists, playlist-folders`), or CSV string when `resourceType` is provided |
| `resourceType` | No | string | Required only when `ids` is provided as a string; same allowed values as above |
| `l` | No | string | Language tag override |

### `add_library_songs`
**Method/Path:** POST `/v1/me/library`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `ids` | Yes | string | Comma-separated song IDs |
| `l` | No | string | Language tag override |

**Notes**
- Apple frequently returns HTTP 405 for library write operations.

### `add_library_albums`
**Method/Path:** POST `/v1/me/library`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `ids` | Yes | string | Comma-separated album IDs |
| `l` | No | string | Language tag override |

### `add_favorites`
**Method/Path:** POST `/v1/me/favorites`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `ids` | Yes | object/string | Object keyed by resource type (allowed keys: `songs, albums, playlists, music-videos, stations`), or CSV string when `resourceType` is provided |
| `resourceType` | No | string | Required only when `ids` is provided as a string; allowed: `songs, albums, playlists, music-videos, stations` |
| `l` | No | string | Language tag override |

### `set_rating`
**Method/Path:** PUT `/v1/me/ratings/{resourceType}/{id}`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `resourceType` | Yes | string | Allowed: `songs, albums, playlists, library-songs, library-albums, library-playlists, library-music-videos, music-videos, stations` |
| `id` | Yes | string | Resource ID |
| `value` | Yes | integer | `1` for like, `-1` for dislike |
| `l` | No | string | Language tag override |

### `delete_rating`
**Method/Path:** DELETE `/v1/me/ratings/{resourceType}/{id}`

**Parameters**
| Name | Required | Type | Allowed values / behavior |
| --- | --- | --- | --- |
| `resourceType` | Yes | string | Allowed: `songs, albums, playlists, library-songs, library-albums, library-playlists, library-music-videos, music-videos, stations` |
| `id` | Yes | string | Resource ID |
| `l` | No | string | Language tag override |

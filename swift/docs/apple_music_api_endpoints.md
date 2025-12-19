# Apple Music API Endpoints Reference (Swift MCP Server)

The Swift MCP server mirrors the TypeScript tool surface. Authentication columns indicate which token is required.

| # | Endpoint | Route | Description | Auth | Status / Notes |
|---|---|---|---|---|---|
| 1 | Catalog Search | GET /v1/catalog/{storefront}/search | Term-based search across songs, albums, artists, playlists, etc. | Developer Token | Stable |
| 2 | Search Suggestions | GET /v1/catalog/{storefront}/search/suggestions | Autocomplete suggestions; requires `kinds` (use `terms`). | Developer Token | Stable (needs `kinds`) |
| 3 | Get Catalog Songs | GET /v1/catalog/{storefront}/songs | Fetch catalog songs by IDs/filters. | Developer Token | Stable |
| 4 | Get Catalog Albums | GET /v1/catalog/{storefront}/albums | Fetch catalog albums with track lists. | Developer Token | Stable |
| 5 | Get Catalog Artists | GET /v1/catalog/{storefront}/artists | Fetch artist metadata and relationships. | Developer Token | Stable |
| 6 | Get Catalog Playlists | GET /v1/catalog/{storefront}/playlists | Curated playlists with editorial notes. | Developer Token | Stable |
| 7 | Get Curators | GET /v1/catalog/{storefront}/curators | Curator info; valid IDs required. | Developer Token | Stable (needs IDs) |
| 8 | Get Radio Shows | GET /v1/catalog/{storefront}/radio-shows | Intended radio show lookup. | Developer Token | Not available (404) |
| 9 | Get Music Videos | GET /v1/catalog/{storefront}/music-videos | Catalog music videos. | Developer Token | Stable |
| 10 | Get Genres | GET /v1/catalog/{storefront}/genres | Genre hierarchy. | Developer Token | Stable |
| 11 | Get Stations | GET /v1/catalog/{storefront}/stations | Radio stations (e.g., Apple Music 1). | Developer Token | Stable (IDs required) |
| 12 | Get Charts | GET /v1/catalog/{storefront}/charts | Top charts by type. | Developer Token | Stable |
| 13 | Get Activities | GET /v1/catalog/{storefront}/activities | Editorial activities/collections. | Developer Token | Returns empty without valid IDs |
| 14 | Get Record Labels | GET /v1/catalog/{storefront}/record-labels | Record label metadata. | Developer Token | Not available as resources |
| 15 | Get Library Playlists | GET /v1/me/library/playlists | User playlists. | User Token | Stable |
| 16 | Get Library Songs | GET /v1/me/library/songs | User songs. | User Token | Stable |
| 17 | Get Library Albums | GET /v1/me/library/albums | User albums. | User Token | Stable |
| 18 | Get Library Artists | GET /v1/me/library/artists | User artists. | User Token | Stable |
| 19 | Get Recently Played | GET /v1/me/recent/played | Recent playback history. | User Token | Stable |
| 20 | Get Recommendations | GET /v1/me/recommendations | Personalized recommendations. | User Token | Stable |
| 21 | Get Replay Data | GET /v1/me/replay/{year} | Annual replay stats. | User Token | Not available (404) |
| 22 | Add Songs to Library | POST /v1/me/library/songs | Save songs to library. | User Token | 405 Method Not Allowed |
| 23 | Add Albums to Library | POST /v1/me/library/albums | Save albums to library. | User Token | 405 Method Not Allowed |
| 24 | Add Items to Playlist | POST /v1/me/library/playlists/{playlistId}/tracks | Add tracks to playlist. | User Token | Stable |
| 25 | Create Playlist | POST /v1/me/library/playlists | Create playlist. | User Token | Stable |
| 26 | Add to Favorites | POST /v1/me/favorites/{resourceType} | Favorite songs/albums/playlists. | User Token | 405 Method Not Allowed |
| 27 | Get Multiple Catalog Resources | GET /v1/catalog/{storefront}/[{type}] | Batch fetch by typed IDs. | Developer Token | Stable |
| 28 | Get Multiple Library Resources | GET /v1/me/library/[{type}] | Batch fetch by typed IDs. | User Token | Stable |
| 29 | Get User Storefront | GET /v1/me/storefront | User region/locale. | User Token | Stable |
| 30 | Generic Data Request | GET /v1/{endpoint} | Passthrough for new endpoints. | Dev or User Token | Stable (validate method/path) |

## Notes for Swift Implementation
- Map these endpoints to MCP tools using the Swift SDK; mark destructive hints appropriately (all non-destructive).
- Handle storefront defaults (use user storefront when available; otherwise default to `us`).
- Enforce pagination inputs (`offset`, `limit`) and surface `next` links in responses where provided.
- For known 404/405 endpoints, keep tools but document the limitation or gate them behind a feature flag.

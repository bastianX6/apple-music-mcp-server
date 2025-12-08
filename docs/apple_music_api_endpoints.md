# Apple Music API Endpoints Reference

| # | Endpoint Name | Route | Description | MCP Apple-Docs Reference | Authentication Required |
|---|---|---|---|---|---|
| 1 | Catalog Search | `GET /v1/catalog/{storefront}/search` | Search across Apple Music catalog by terms, returning typed results for songs, albums, artists, playlists, and more | `search` | Developer Token |
| 2 | Search Suggestions | `GET /v1/catalog/{storefront}/search/suggestions` | Provides autocomplete suggestions based on partial search terms entered by the user | `search` | Developer Token |
| 3 | Get Catalog Songs | `GET /v1/catalog/{storefront}/songs` | Retrieves specific songs from the catalog by IDs or filters, including complete metadata | `songs-api` | Developer Token |
| 4 | Get Catalog Albums | `GET /v1/catalog/{storefront}/albums` | Retrieves specific albums from the catalog by IDs or filters with artist and track information | `albums-api` | Developer Token |
| 5 | Get Catalog Artists | `GET /v1/catalog/{storefront}/artists` | Retrieves specific artists from the catalog with biography and related works information | `artists-api` | Developer Token |
| 6 | Get Catalog Playlists | `GET /v1/catalog/{storefront}/playlists` | Retrieves curated playlists from the Apple Music catalog with descriptions and content | `playlists-api` | Developer Token |
| 7 | Get Curators | `GET /v1/catalog/{storefront}/curators` | Obtains information about Apple Music curators and their music selections | `curators-api` | Developer Token |
| 8 | Get Radio Shows | `GET /v1/catalog/{storefront}/radio-shows` | Retrieves radio programs available in Apple Music | `apple-music-stations` | Developer Token |
| 9 | Get Music Videos | `GET /v1/catalog/{storefront}/music-videos` | Retrieves music videos from the catalog | `music-videos-api` | Developer Token |
| 10 | Get Genres | `GET /v1/catalog/{storefront}/genres` | Retrieves information about available music genres | `music-genres` | Developer Token |
| 11 | Get Stations | `GET /v1/catalog/{storefront}/stations` | Retrieves available radio stations in Apple Music | `apple-music-stations` | Developer Token |
| 12 | Get Charts | `GET /v1/catalog/{storefront}/charts` | Retrieves music charts and trends (Top Charts, City Charts, etc.) | `charts-api` | Developer Token |
| 13 | Get Activities | `GET /v1/catalog/{storefront}/activities` | Retrieves editorial activities and curated content collections | `activities-api` | Developer Token |
| 14 | Get Record Labels | `GET /v1/catalog/{storefront}/record-labels` | Retrieves information about record labels in the Apple Music catalog | `record-labels-api` | Developer Token |
| 15 | Get Library Playlists | `GET /v1/me/library/playlists` | Accesses user's saved playlists from personal library | None | User Token |
| 16 | Get Library Songs | `GET /v1/me/library/songs` | Accesses user's saved songs from personal library | None | User Token |
| 17 | Get Library Albums | `GET /v1/me/library/albums` | Accesses user's saved albums from personal library | None | User Token |
| 18 | Get Library Artists | `GET /v1/me/library/artists` | Accesses user's saved artists from personal library | None | User Token |
| 19 | Get Recently Played | `GET /v1/me/recent/played` | Retrieves user's recent playback history and recently played content | `history` | User Token |
| 20 | Get Personal Recommendations | `GET /v1/me/recommendations` | Retrieves personalized recommendations based on user's listening history | `recommendations` | User Token |
| 21 | Get User Replay Data | `GET /v1/me/replay/{year}` | Retrieves user's annual replay data summarizing their listening statistics | `Get-the-user's-replay-data` | User Token |
| 22 | Add Songs to Library | `POST /v1/me/library/songs` | Saves songs to user's personal library | None | User Token |
| 23 | Add Albums to Library | `POST /v1/me/library/albums` | Saves albums to user's personal library | None | User Token |
| 24 | Add Items to Playlist | `POST /v1/me/library/playlists/{playlistId}/tracks` | Adds songs to an existing user playlist | None | User Token |
| 25 | Create New Playlist | `POST /v1/me/library/playlists` | Creates a new playlist in user's personal library | None | User Token |
| 26 | Add Resource to Favorites | `POST /v1/me/favorites` | Adds a resource (song, album, playlist, etc.) to user's favorites | `Add-resource-to-favorites` | User Token |
| 27 | Get Multiple Catalog Resources | `GET /v1/catalog/{storefront}/[{type}]` | Retrieves multiple catalog resources of different types by typed IDs in a single request | `Get-Multiple-Catalog-Resources-by-resource-typed-ids-parameters` | Developer Token |
| 28 | Get Multiple Library Resources | `GET /v1/me/library/[{type}]` | Retrieves multiple library resources of different types by typed IDs in a single request | `Get-Multiple-Library-Resources-by-resource-typed-ids-parameters` | User Token |
| 29 | Get User Storefront | `GET /v1/me/storefront` | Retrieves the user's Apple Music storefront (region/locale) | `Get-a-User's-Storefront` | User Token |
| 30 | Generic Data Request | `GET /v1/{endpoint}` | Generic access to any Apple Music API endpoint for maximum flexibility and extensibility | `handling-requests-and-responses` | Developer Token or User Token |

## Authentication Types

### Developer Token
- **Usage**: Required for catalog-related endpoints (search, browse, discover)
- **Generated**: Using a MusicKit identifier and private key
- **Scope**: Catalog data only, no access to user personal library
- **Reference**: `generating-developer-tokens`

### User Token
- **Usage**: Required for personalized endpoints (library, history, recommendations)
- **Generated**: After user authorization via MusicKit
- **Scope**: User's personal library and listening history
- **Reference**: `user-authentication-for-musickit`

## Common Parameters

- **{storefront}**: Two-letter country code (e.g., `us`, `es`, `gb`, `fr`) - Required for catalog endpoints
- **{playlistId}**: Unique identifier for a playlist
- **{year}**: Calendar year for replay data (e.g., `2024`)
- **{type}**: Resource type (songs, albums, playlists, artists, etc.)
- **{endpoint}**: Any valid Apple Music API endpoint path

## Notes for MCP Server Implementation

1. **MCP Apple-Docs References**: The "MCP Apple-Docs Reference" column contains identifiers that can be used to query the apple-docs MCP server for detailed endpoint documentation
2. **Authentication Strategy**: Implement dual-token system with Developer Token for catalog operations and User Token for personalized features
3. **Extensibility**: The Generic Data Request endpoint (#30) enables future feature additions without core architecture changes
4. **Pagination**: All list-returning endpoints support pagination - refer to `fetching-resources-by-page` documentation
5. **Storefronts**: Use user's storefront endpoint to determine appropriate region for catalog queries
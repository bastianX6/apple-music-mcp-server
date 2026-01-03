# Hybrid Tool Smoke Prompts

Each prompt explicitly names the tool to reduce LLM ambiguity. Replace placeholders as needed.

## Catalog search
1) Call `search_catalog` with arguments `{ "term": "radiohead", "types": "songs,albums", "limit": 5 }`.
2) Call `get_search_hints` with arguments `{ "term": "tay" }`.
3) Call `get_search_suggestions` with arguments `{ "term": "daft", "kinds": "terms" }`.

## Catalog lookups (intent tools)
4) Call `get_catalog_songs` with arguments `{ "ids": "203709340" }`.
5) Call `get_catalog_albums` with arguments `{ "ids": "310730204" }`.
6) Call `get_catalog_artists` with arguments `{ "ids": "909253" }`.
7) Call `get_catalog_playlists` with arguments `{ "ids": "pl.u-76oNppP" }`.
8) Call `get_music_videos` with arguments `{ "ids": "880175343" }`.
9) Call `get_stations` with arguments `{ "ids": "ra.978194965" }`.
10) Call `get_genres` with arguments `{}`.
11) Call `get_charts` with arguments `{ "types": "songs", "chart": "most-played", "limit": 5 }`.

## Catalog generic tools
12) Call `get_catalog_resources` with arguments `{ "type": "songs", "ids": "203709340,203709341" }`.
13) Call `get_catalog_resource` with arguments `{ "type": "albums", "id": "310730204" }`.
14) Call `get_catalog_relationship` with arguments `{ "type": "songs", "id": "203709340", "relationship": "albums", "limit": 5 }`.
15) Call `get_catalog_view` with arguments `{ "type": "artists", "id": "909253", "view": "top-songs", "limit": 5 }`.
16) Call `get_catalog_multi_by_type_ids` with arguments `{ "ids": { "songs": "203709340", "albums": "310730204" } }`.

## Library convenience tools (requires Music-User-Token)
17) Call `get_library_playlists` with arguments `{ "limit": 5 }`.
18) Call `get_library_songs` with arguments `{ "limit": 5 }`.
19) Call `get_library_albums` with arguments `{ "limit": 5 }`.
20) Call `get_library_artists` with arguments `{ "limit": 5 }`.
21) Call `library_search` with arguments `{ "term": "radiohead", "types": "library-songs", "limit": 5 }`.
22) Call `get_library_recently_added` with arguments `{}`.

## Library generic tools
23) Call `get_library_resources` with arguments `{ "type": "playlists", "ids": "p.123456789" }`.
24) Call `get_library_resource` with arguments `{ "type": "albums", "id": "l.123456789" }`.
25) Call `get_library_relationship` with arguments `{ "type": "playlists", "id": "p.123456789", "relationship": "tracks", "limit": 5 }`.
26) Call `get_library_multi_by_type_ids` with arguments `{ "ids": { "library-songs": "l.123", "library-albums": "l.456" } }`.

## User history and recommendations (requires Music-User-Token)
27) Call `get_recently_played` with arguments `{ "limit": 5 }`.
28) Call `get_recently_played_tracks` with arguments `{ "limit": 5, "types": "songs" }`.
29) Call `get_recently_played_stations` with arguments `{ "limit": 5 }`.
30) Call `get_recommendations` with arguments `{ "limit": 5 }`.
31) Call `get_recommendation` with arguments `{ "id": "<recommendation-id>" }`.
32) Call `get_recommendation_relationship` with arguments `{ "id": "<recommendation-id>", "relationship": "contents", "limit": 5 }`.
33) Call `get_heavy_rotation` with arguments `{ "limit": 5 }`.
34) Call `get_replay_data` with arguments `{ "filter[year]": "2024", "views": "top-songs" }`.

## Storefront and language
35) Call `get_user_storefront` with arguments `{}`.
36) Call `get_best_language_tag` with arguments `{ "storefront": "us", "acceptLanguage": "es-ES" }`.

## Playlist management (requires Music-User-Token)
37) Call `create_playlist` with arguments `{ "name": "Smoke Test Playlist", "description": "Created by MCP smoke test" }`.
38) Call `add_playlist_tracks` with arguments `{ "playlistId": "p.123456789", "trackIds": "203709340,203709341" }`.
39) Call `create_playlist_folder` with arguments `{ "name": "Smoke Test Folder" }`.

## Add to library / favorites (expected 405 in many cases)
40) Call `add_library_resources` with arguments `{ "ids": { "songs": "203709340" } }` and confirm the tool surfaces a 405 limitation if it occurs.
41) Call `add_favorites` with arguments `{ "ids": "203709340" }` and confirm the tool surfaces a 405 limitation if it occurs.

## Ratings (requires Music-User-Token)
42) Call `set_rating` with arguments `{ "resourceType": "songs", "id": "203709340", "value": "like" }`.
43) Call `delete_rating` with arguments `{ "resourceType": "songs", "id": "203709340" }`.

## Escape hatch
44) Call `generic_get` with arguments `{ "path": "v1/catalog/us/search?term=radiohead&types=songs&limit=3" }`.

## Special verification (404/405 prone)
45) Call `add_library_resources` with arguments `{ "ids": { "songs": "203709340" } }` and record the HTTP status (expect 202 or 405 depending on account permissions).
46) Call `add_favorites` with arguments `{ "ids": "203709340" }` and record the HTTP status (expect 202 or 405 depending on account permissions).
47) Call `get_replay_data` with arguments `{ "filter[year]": "<available-year-for-account>", "views": "top-songs" }` and note if the API returns data or 404/empty.
48) Call `get_catalog_resources` with arguments `{ "type": "record-labels", "ids": "<label-id>" }` to see if the storefront returns data or 404.
49) Call `get_catalog_relationship` with arguments `{ "type": "stations", "id": "ra.978194965", "relationship": "radio-show" }` and note whether the relationship exists (may return 404/empty).

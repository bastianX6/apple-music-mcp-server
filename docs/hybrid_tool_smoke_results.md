# Hybrid Tool Smoke Results (partial)

Ran steps 1–28 from docs/hybrid_tool_smoke_prompts.md. Catalog region resolved to CL. Library/user calls used provided Music-User-Token.

## Catalog search
1) search_catalog term=radiohead types=songs,albums limit=5 → OK (songs + albums returned).
2) get_search_hints term=tay → OK (top hint: "taylor swift").
3) get_search_suggestions term=daft kinds=terms → OK ("daft punk" etc.).

## Catalog lookups
4) get_catalog_songs ids=203709340 → OK (Bruce Springsteen - Dancing In the Dark).
5) get_catalog_albums ids=310730204 → OK (Born to Run, tracks embedded).
6) get_catalog_artists ids=909253 → OK (Jack Johnson, albums relationship present).
7) get_catalog_playlists ids=pl.u-76oNppP → EMPTY (no data).
8) get_music_videos ids=880175343 → EMPTY (no data).
9) get_stations ids=ra.978194965 → OK (Apple Music 1, live stream).
10) get_genres → OK (genre list returned).
11) get_charts types=songs chart=most-played limit=5 → OK (5 songs returned).

## Catalog generic tools
12) get_catalog_resources type=songs ids=203709340,203709341 → PARTIAL (203709340 returned; 203709341 missing).
13) get_catalog_resource type=albums id=310730204 → OK (Born to Run with tracks).
14) get_catalog_relationship songs/203709340 → OK (albums relationship: Born In the U.S.A.).
15) get_catalog_view artists/909253 view=top-songs limit=5 → OK (top 5 songs listed).
16) get_catalog_multi_by_type_ids songs=203709340, albums=310730204 → OK (both returned).

## Library convenience tools (Music-User-Token)
17) get_library_playlists limit=5 → OK (5 playlists, next link present).
18) get_library_songs limit=5 → OK (5 songs, next link present).
19) get_library_albums limit=5 → OK (5 albums, next link present).
20) get_library_artists limit=5 → OK (5 artists, next link present).
21) library_search term=radiohead types=library-songs limit=5 → OK (5 hits).
22) get_library_recently_added → OK (10 items; mix of albums/playlists).

## Library generic tools
23) get_library_resources type=playlists ids=p.123456789 → OK (stub playlist returned, non-editable).
24) get_library_resource type=albums id=l.123456789 → 404 (Resource Not Found).
25) get_library_relationship playlists/p.123456789 tracks limit=5 → 404 (No related resources).
26) get_library_multi_by_type_ids {library-songs:l.123, library-albums:l.456} → EMPTY.

## User history and recommendations
27) get_recently_played limit=5 → OK (4 playlists returned, next link present).
28) get_recently_played_tracks limit=5 types=songs → OK (5 songs, next link present).
29) get_recently_played_stations limit=5 → OK (3 stations; next link present).
30) get_recommendations limit=5 → OK (multiple personal-recommendation blocks with playlists/albums/stations; next link present).
31) get_heavy_rotation limit=5 → OK (mix of library playlists/albums; next link present).
32) get_replay_data filter[year]=2024 views=top-songs → 400 (Bad Request: No filters supplied).
33) get_user_storefront {} → OK (storefront cl, explicit allowed, default language es-MX).
34) get_best_language_tag storefront=us acceptLanguage=es-ES → OK (es-MX).
35) get_recommendation id=6-27s5hU6azhJY → OK (Hechos para ti playlists bundle returned).
36) get_recommendation_relationship id=6-27s5hU6azhJY relationship=contents limit=5 → OK (playlists: Chill, Nueva música, En loop, Tus essentials, ¡Anímate!).

## Playlist management
37) create_playlist name="Smoke Test Playlist" → OK (library-playlists id=p.2P6WelKC66XLoq, editable).
38) add_playlist_tracks playlistId=p.123456789 trackIds=203709340,203709341 → 404 (Resource Not Found in user library).
39) create_playlist_folder name="Smoke Test Folder" → OK (library-playlist-folders id=p.pmrA8LguggazJ9).

## Library / favorites / ratings / escape hatch
40) add_library_resources songs=203709340 → EMPTY (no body returned; likely accepted or ignored).
41) add_favorites ids=203709340 → 400 (Invalid Parameter Value: single resource type required).
42) set_rating resourceType=songs id=1097862231 value=1 → OK (rating created value=1).
43) delete_rating resourceType=songs id=1097862231 → EMPTY (delete succeeded).
44) generic_get v1/catalog/us/search?term=radiohead&types=songs&limit=3 → OK (3 songs, next link present).
45) add_library_resources songs=203709340 → EMPTY (same behavior as step 40).
46) add_favorites ids=203709340 → 400 (same invalid parameter value error).
47) get_replay_data filter[year]=2023 views=top-songs → 400 (Bad Request: No filters supplied).

## Special verification
48) get_catalog_resources type=record-labels ids=1234 → EMPTY (no data).
49) get_catalog_relationship stations/ra.978194965 radio-show → 404 (No related resources).

## Follow-up fix notes (for LLM remediation)
- Library IDs used in steps 23/24/25/38 are not real (e.g., p.123456789, l.123456789, l.123, l.456). Replace with real library IDs or mock fixtures before re-running `get_library_resource`, `get_library_relationship`, and `add_playlist_tracks`.
- `get_replay_data` returned 400 “No filters supplied” for both years 2024 and 2023. Identify mandatory query parameters (likely `views` and `filter[year]`, possibly storefront or additional filters) and enforce them in the tool schema so calls include the required fields.
- `add_favorites` returned 400 “Invalid Parameter Value: Please provide a single (1) resource type”. The tool likely needs explicit resourceType-specific parameterization (e.g., songs vs albums vs playlists) and should surface required parameters in the schema to avoid ambiguous ids-only calls.
- `get_catalog_relationship` step 49 used stations/ra.978194965 radio-show and returned 404; this may be an unsupported relationship or requires a different station id. Confirm valid relationship targets and update prompts or tool guidance accordingly.

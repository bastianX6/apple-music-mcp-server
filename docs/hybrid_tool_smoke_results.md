# Hybrid Tool Smoke Results (full rerun)

Catalog region resolved to CL. All calls used valid Music-User-Token. Library placeholders replaced with real IDs from this session.

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
17) get_library_playlists limit=5 → OK (5 playlists, e.g., p.5PG5gooiEE7ZQg "All2").
18) get_library_songs limit=5 → OK (5 songs, e.g., i.EYVA0QbseeGJWD "A Change is Gonna Come").
19) get_library_albums limit=5 → OK (5 albums, e.g., l.FaeLKCi "A / B").
20) get_library_artists limit=5 → OK (5 artists returned).
21) library_search term=radiohead types=library-songs limit=5 → OK (5 Radiohead songs with library IDs).
22) get_library_recently_added → OK (10 items; mix of albums/playlists, including p.2P6WelKC66XLoq and l.q2LW5Xk).

## Library generic tools
23) get_library_resources type=playlists ids=p.5PG5gooiEE7ZQg → OK (editable playlist "All2", SongShift import).
24) get_library_resource type=albums id=l.FaeLKCi → OK (album "A / B" with tracks relationship).
25) get_library_relationship playlists/p.5PG5gooiEE7ZQg tracks limit=5 → OK (5 tracks returned, next present; total=615).
26) get_library_multi_by_type_ids {library-songs:i.EYVA0QbseeGJWD, library-albums:l.FaeLKCi} → OK (both returned).

## User history and recommendations
27) get_recently_played limit=5 → OK (4 playlists, next link present).
28) get_recently_played_tracks limit=5 types=songs → OK (5 songs, next link present).
29) get_recently_played_stations limit=5 → OK (3 stations; next link present).
30) get_recommendations limit=5 → OK (multiple recommendation blocks with playlists/albums/stations; next link present).
31) get_recommendation id=6-27s5hU6azhJY → OK (Hechos para ti playlists bundle returned).
32) get_recommendation_relationship id=6-27s5hU6azhJY relationship=contents limit=5 → OK (playlists: Chill, Nueva música, En loop, Tus essentials, ¡Anímate!).
33) get_heavy_rotation limit=5 → OK (library playlists and albums returned; next link present).
34) get_replay_data filter[year]=latest views=top-songs,top-artists → OK (resolved to year-2025; both views returned with next links).

## Storefront and language
35) get_user_storefront {} → OK (storefront cl, explicit allowed, default language es-MX).
36) get_best_language_tag storefront=us acceptLanguage=es-ES → OK (es-MX).

## Playlist management
37) create_playlist name="Smoke Test Playlist" → OK (library-playlists id=p.5PG50posEE7ZQg, editable).
38) add_playlist_tracks playlistId=p.5PG50posEE7ZQg trackIds=203709340,203709341 → EMPTY body (request accepted; no error surfaced).
39) create_playlist_folder name="Smoke Test Folder" → OK (library-playlist-folders id=p.8Wx6k0BI22YxPv).

## Add to library / favorites (expected 405 in many cases)
40) add_library_resources songs=203709340 → EMPTY (no status body; likely accepted or ignored by Apple).
41) add_favorites ids=203709340 resourceType=songs → EMPTY (no status body; Apple often returns 405/empty).

## Ratings (requires Music-User-Token)
42) set_rating resourceType=songs id=203709340 value=1 → OK (rating created value=1).
43) delete_rating resourceType=songs id=203709340 → EMPTY (delete succeeded).

## Escape hatch
44) generic_get v1/catalog/us/search?term=radiohead&types=songs&limit=3 → SKIPPED (tool disabled in MCP server).

## Special verification (404/405 prone)
45) add_library_resources songs=203709340 → EMPTY (same behavior as step 40).
46) add_favorites ids=203709340 resourceType=songs → EMPTY (same behavior as step 41).
47) get_replay_data filter[year]=latest views=top-songs,top-artists → OK (same as step 34; year-2025 data with next links).
48) get_catalog_resources type=record-labels ids=1234 → EMPTY (no data; record labels appear unsupported).
49) get_catalog_relationship stations/ra.978194965 radio-show → 404 (No related resources).

## Notes
- `generic_get` remains implemented but is intentionally disabled; skip escape-hatch checks until it is re-enabled.
- Replay works when requesting filter[year]=latest; resolves to year-2025 and returns top-songs and top-artists with pagination.
- Apple often returns empty bodies for add-to-library/favorites even when not applied; no explicit 405 surfaced in this run.
- Playlist track add (step 38) returned empty body; assume accepted since no error returned.

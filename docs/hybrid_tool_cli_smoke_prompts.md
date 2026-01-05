# CLI Smoke Prompts (apple-music-tool)

These prompts assume the SwiftPM executable target `apple-music-tool` is available via `swift run apple-music-tool ...` without building the release binary. Ensure config is created first with `swift run apple-music-tool setup --config <path> ...` (requires env vars for dev token: `APPLE_MUSIC_TEAM_ID`, `APPLE_MUSIC_MUSICKIT_ID`, `APPLE_MUSIC_PRIVATE_KEY`).

## Catalog & language
1) `swift run apple-music-tool get-user-storefront`
2) `swift run apple-music-tool search-catalog --term "nirvana" --types songs --limit 3`
3) `swift run apple-music-tool get-search-hints --term "ta" --limit 5`
4) `swift run apple-music-tool get-search-suggestions --term "taylor" --types songs --limit 5`
5) `swift run apple-music-tool get-charts --types songs --limit 5`
6) `swift run apple-music-tool get-genres`
7) `swift run apple-music-tool get-stations --ids ra.978194965`
8) `swift run apple-music-tool get-catalog-songs --ids 310730204`
9) `swift run apple-music-tool get-catalog-albums --ids 310730204`
10) `swift run apple-music-tool get-catalog-artists --ids 178834`
11) `swift run apple-music-tool get-catalog-playlists --ids pl.acc464706d7541c28ab57c8a092b3a7e`
12) `swift run apple-music-tool get-music-videos --ids 1571159355`
13) `swift run apple-music-tool get-curators --ids pl.f4d1063de2a74144a1d43e1a2f1c8bcc`
14) `swift run apple-music-tool get-activities --ids fitness`
15) `swift run apple-music-tool get-catalog-resources --type songs --ids 310730204`
16) `swift run apple-music-tool get-catalog-resource --type songs --id 310730204`
17) `swift run apple-music-tool get-catalog-relationship --type artists --id 178834 --relationship albums --limit 2`
18) `swift run apple-music-tool get-catalog-view --type playlists --id pl.acc464706d7541c28ab57c8a092b3a7e --view full`
19) `swift run apple-music-tool get-catalog-multi-by-type-ids --ids songs=310730204 --ids albums=310730204`
20) `swift run apple-music-tool get-best-language-tag --accept-language es-ES`
21) `swift run apple-music-tool get-record-labels` (expected error envelope)
22) `swift run apple-music-tool get-radio-shows` (expected error envelope)

## Library (requires Music-User-Token)
23) `swift run apple-music-tool get-library-playlists --limit 5`
24) `swift run apple-music-tool get-library-songs --limit 5`
25) `swift run apple-music-tool get-library-albums --limit 5`
26) `swift run apple-music-tool get-library-artists --limit 5`
27) `swift run apple-music-tool get-library-resources --type songs --limit 5`
28) `swift run apple-music-tool get-library-resource --type songs --id i.e.123456789`
29) `swift run apple-music-tool get-library-relationship --type playlists --id p.xxxxx --relationship tracks --limit 2`
30) `swift run apple-music-tool get-library-multi-by-type-ids --ids songs=i.e.123456789`
31) `swift run apple-music-tool library-search --term "beatles" --types songs --limit 3`
32) `swift run apple-music-tool get-library-recently-added --limit 5`

## History / recommendations
33) `swift run apple-music-tool get-recently-played --limit 5`
34) `swift run apple-music-tool get-recently-played-tracks --limit 5`
35) `swift run apple-music-tool get-recently-played-stations --limit 5`
36) `swift run apple-music-tool get-recommendations --limit 5`
37) `swift run apple-music-tool get-recommendation --id r.xx`
38) `swift run apple-music-tool get-recommendation-relationship --id r.xx --relationship tracks --limit 2`
39) `swift run apple-music-tool get-heavy-rotation --limit 5`
40) `swift run apple-music-tool get-replay-data --filter-year latest --views top-songs`
41) `swift run apple-music-tool get-replay` (expected error envelope)

## Write (may return 405; best-effort)
42) `swift run apple-music-tool create-playlist --name "CLI Smoke Playlist" --description "Created by smoke"`
43) `swift run apple-music-tool create-playlist-folder --name "CLI Smoke Folder"`
44) `swift run apple-music-tool add-playlist-tracks --playlist-id p.xxxxx --track-ids 310730204`
45) `swift run apple-music-tool add-library-resources --ids songs=310730204`
46) `swift run apple-music-tool add-library-songs --ids 310730204`
47) `swift run apple-music-tool add-library-albums --ids 310730204`
48) `swift run apple-music-tool add-favorites --ids songs=310730204`
49) `swift run apple-music-tool set-rating --resource-type songs --id 310730204 --value 1`
50) `swift run apple-music-tool delete-rating --resource-type songs --id 310730204`

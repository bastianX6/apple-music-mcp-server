# CLI Smoke Prompts (apple-music-tool)

These prompts assume the SwiftPM executable target `apple-music-tool` is available via `swift run apple-music-tool ...` without building the release binary. Ensure config is created first with `swift run apple-music-tool setup --config <path> ...` (requires env vars for dev token: `APPLE_MUSIC_TEAM_ID`, `APPLE_MUSIC_MUSICKIT_ID`, `APPLE_MUSIC_PRIVATE_KEY`).

## Catalog & language
1) `swift run apple-music-tool get-user-storefront`
2) `swift run apple-music-tool search-catalog --term "nirvana" --types songs,albums,artists --limit 3` → capture one `songId`, one `albumId`, one `artistId` from the response for reuse.
3) `swift run apple-music-tool get-search-hints --term "ta" --limit 5`
4) `swift run apple-music-tool get-search-suggestions --term "taylor" --types songs --limit 5`
5) `swift run apple-music-tool get-charts --types songs --limit 5`
6) `swift run apple-music-tool get-genres`
7) `swift run apple-music-tool get-stations --ids ra.978194965`
8) `swift run apple-music-tool get-catalog-songs --ids <songId>`
9) `swift run apple-music-tool get-catalog-albums --ids <albumId>`
10) `swift run apple-music-tool get-catalog-artists --ids <artistId>`
11) `swift run apple-music-tool get-catalog-playlists --ids <catalogPlaylistId>` (use any playlist id from charts/search output if present; otherwise skip)
12) `swift run apple-music-tool get-music-videos --ids <musicVideoId>` (take from search if available; otherwise skip)
13) `swift run apple-music-tool get-curators --ids pl.f4d1063de2a74144a1d43e1a2f1c8bcc` (Apple curator id is stable)
14) `swift run apple-music-tool get-activities --ids fitness`
15) `swift run apple-music-tool get-catalog-resources --type songs --ids <songId>`
16) `swift run apple-music-tool get-catalog-resource --type songs --id <songId>`
17) `swift run apple-music-tool get-catalog-relationship --type artists --id <artistId> --relationship albums --limit 2`
18) `swift run apple-music-tool get-catalog-view --type playlists --id <catalogPlaylistId> --view full`
19) `swift run apple-music-tool get-catalog-multi-by-type-ids --ids songs=<songId> --ids albums=<albumId>`
20) `swift run apple-music-tool get-best-language-tag --accept-language es-ES`
21) `swift run apple-music-tool get-record-labels` (expected error envelope)
22) `swift run apple-music-tool get-radio-shows` (expected error envelope)

## Library (requires Music-User-Token)
23) `swift run apple-music-tool get-library-playlists --limit 5`
24) `swift run apple-music-tool get-library-songs --limit 5`
25) `swift run apple-music-tool get-library-albums --limit 5`
26) `swift run apple-music-tool get-library-artists --limit 5`
27) `swift run apple-music-tool get-library-resources --type songs --limit 5`
28) `swift run apple-music-tool get-library-resource --type songs --id <librarySongId>` (grab from step 24 or 25 output)
29) `swift run apple-music-tool get-library-relationship --type playlists --id <libraryPlaylistId> --relationship tracks --limit 2` (grab id from step 23 output)
30) `swift run apple-music-tool get-library-multi-by-type-ids --ids songs=<librarySongId>`
31) `swift run apple-music-tool library-search --term "beatles" --types songs --limit 3`
32) `swift run apple-music-tool get-library-recently-added --limit 5`

## History / recommendations
33) `swift run apple-music-tool get-recently-played --limit 5`
34) `swift run apple-music-tool get-recently-played-tracks --limit 5`
35) `swift run apple-music-tool get-recently-played-stations --limit 5`
36) `swift run apple-music-tool get-recommendations --limit 5`
37) `swift run apple-music-tool get-recommendation --id <recommendationId>` (capture from step 36 output)
38) `swift run apple-music-tool get-recommendation-relationship --id <recommendationId> --relationship tracks --limit 2`
39) `swift run apple-music-tool get-heavy-rotation --limit 5`
40) `swift run apple-music-tool get-replay-data --filter-year latest --views top-songs`
41) `swift run apple-music-tool get-replay` (expected error envelope)

## Write (may return 405; best-effort)
42) `swift run apple-music-tool create-playlist --name "CLI Smoke Playlist" --description "Created by smoke"` → capture `newPlaylistId` from response.
43) `swift run apple-music-tool create-playlist-folder --name "CLI Smoke Folder"`
44) `swift run apple-music-tool add-playlist-tracks --playlist-id <newPlaylistId> --track-ids <songId>`
45) `swift run apple-music-tool add-library-resources --ids songs=<songId>`
46) `swift run apple-music-tool add-library-songs --ids <songId>`
47) `swift run apple-music-tool add-library-albums --ids <albumId>`
48) `swift run apple-music-tool add-favorites --ids songs=<songId>`
49) `swift run apple-music-tool set-rating --resource-type songs --id <songId> --value 1`
50) `swift run apple-music-tool delete-rating --resource-type songs --id <songId>`

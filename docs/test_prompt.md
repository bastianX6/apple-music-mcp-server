# Apple Music MCP Server – End-to-End Tool Test Prompt

Use this prompt inside your MCP-compatible client to exercise every tool. It assumes the server is already running and configured with valid developer and user tokens.

## Prompt (paste into your MCP client)
You are connected to an Apple Music MCP server. Run the following checks using MCP tools (not by calling external APIs yourself). After each call, briefly report the response status and key fields. If a tool requires user token and it is missing, state that clearly.

1) Enumerate tools to confirm availability.
2) Catalog search smoke test:
   - Call `search_catalog` with `term="beatles"`, `limit=3`, `storefront="us"`.
   - Verify: no errors, results list present.
3) Search suggestions:
   - Call `get_search_suggestions` with `term="tayl"`, `storefront="us"`.
   - Verify: suggestions array returned.
4) Catalog songs by ids:
   - Call `get_catalog_songs` with `ids="900032829"`, `storefront="us"`.
   - Verify: track metadata present (name/artist).
5) Catalog albums by ids:
   - Call `get_catalog_albums` with `ids="310730204"`, `storefront="us"`.
   - Verify: album title and track list present.
6) Catalog artists by ids:
   - Call `get_catalog_artists` with `ids="262836961"`, `storefront="us"`.
   - Verify: artist name present.
7) Catalog playlists (by ids):
   - Call `get_catalog_playlists` with `ids="pl.acc4642c3d1b4ed88027d0105a1cc2fc"`, `storefront="us"`.
   - Verify: playlist title present.
8) Catalog charts:
   - Call `get_charts` with `types="songs"`, `storefront="us"`, `limit=5`.
   - Verify: chart items returned.
9) Catalog stations:
   - Call `get_stations` with `ids="ra.978194965"`, `storefront="us"`.
   - Verify: station metadata present.
10) Catalog genres:
   - Call `get_genres` with `storefront="us"`.
   - Verify: genre list present.
11) Generic catalog passthrough:
   - Call `generic_get` with `path="v1/catalog/us/search?term=radiohead"`.
   - Verify: succeeds and includes results.
12) Library playlists (requires user token):
   - Call `get_library_playlists` with `limit=5`.
   - Verify: list returned or explicit missing-token error.
13) Library songs (requires user token):
   - Call `get_library_songs` with `limit=5`.
   - Verify: songs returned or explicit missing-token error.
14) Library albums (requires user token):
   - Call `get_library_albums` with `limit=5`.
   - Verify: albums returned or explicit missing-token error.
15) Library artists (requires user token):
   - Call `get_library_artists` with `limit=5`.
   - Verify: artists returned or explicit missing-token error.
16) Library resources by type:
   - Call `get_library_resources` with `type="songs"`, `ids="<comma-separated known ids or leave blank to trigger validation>"`.
   - Verify: succeeds with data or shows validation error if ids missing.
17) Recently played (requires user token):
   - Call `get_recently_played` with `limit=5`.
   - Verify: items returned or missing-token error.
18) Recommendations (requires user token):
   - Call `get_recommendations` with `limit=5`.
   - Verify: items returned or missing-token error.
19) Heavy rotation (requires user token):
   - Call `get_heavy_rotation` with `limit=5`.
   - Verify: items returned or missing-token error.
20) Replay (known unsupported):
   - Call `get_replay` with no args.
   - Verify: informative error mentioning replay not available.
21) Add favorites (known 405):
   - Call `add_favorites` with `resourceType="songs"`, `ids="900032829"`.
   - Verify: informative 405 message.
22) Add library songs (known 405):
   - Call `add_library_songs` with `ids="900032829"`.
   - Verify: informative 405 message.
23) Create playlist (requires user token; will fail without token):
   - Call `create_playlist` with `name="MCP Test"`, `description="Test playlist"`.
   - Verify: success if permissions allow; otherwise explicit missing-token or 405 response.
24) Add playlist tracks (requires user token):
   - Call `add_playlist_tracks` with `playlistId="<existing library playlist id>", trackIds="900032829"`.
   - Verify: success or explicit error if missing token/permissions.
25) User storefront (requires user token):
   - Call `get_user_storefront` with no args.
   - Verify: storefront code returned or missing-token error.

After all calls, summarize: how many succeeded, how many returned expected validation/405/missing-token messages. Do not refuse to use MCP tools; interact with them directly.

# Apple Music MCP Server (Swift)

An MCP server that exposes Apple Music API operations (catalog, library, recommendations, playlist management, and utility passthrough) over STDIO using the MCP Swift SDK. Tested on macOS 13+ and Swift 6 on Linux (x86_64, swift.org toolchains).

## Installation

### Using install.sh (recommended)
- From the repo root:
   ```bash
   bash ./install.sh
   ```
- The script builds `apple-music-mcp` in release and installs the binary to `$HOME/.local/bin/apple-music-mcp` (directory is created if missing).
- On Linux, ensure the Swift toolchain (Swift 6) and basic build tools are installed; the script works the same.

### Manual installation (source-based)
1) From the Swift package directory (repo root), build in release:
   ```bash
   swift build -c release --product apple-music-mcp
   ```
2) Copy the server binary to your MCP bin path:
   ```bash
   mkdir -p "$HOME/.local/bin"
   install -m 755 .build/release/apple-music-mcp "$HOME/.local/bin/apple-music-mcp"
   ```

## Configuration

### Config file
- The server only reads credentials from `~/Library/Application Support/apple-music-mcp/config.json` (0600 permissions enforced).
- Override the location with `--config /path/to/config.json` on either the `run` or `setup` subcommand.
- If the file is missing, `apple-music-mcp` exits with an error reminding you to run `setup`.

### Required environment variables for `setup`
- `APPLE_MUSIC_TEAM_ID`
- `APPLE_MUSIC_MUSICKIT_ID`
- `APPLE_MUSIC_PRIVATE_KEY` (inline PEM)

The `setup` subcommand builds the config file exclusively from those environment variables plus the Music-User-Token you provide (CLI or browser helper). Missing env vars now cause `setup` to fail fast.

### User token setup
- CLI mode (persist an existing token):
   ```bash
   APPLE_MUSIC_TEAM_ID="<team>" \
   APPLE_MUSIC_MUSICKIT_ID="<kid>" \
   APPLE_MUSIC_PRIVATE_KEY="$(cat /path/to/AuthKey.p8)" \
   swift run apple-music-mcp setup --token "<user-token>"
   # Using the installed binary
   APPLE_MUSIC_TEAM_ID="<team>" \
   APPLE_MUSIC_MUSICKIT_ID="<kid>" \
   APPLE_MUSIC_PRIVATE_KEY="$(cat /path/to/AuthKey.p8)" \
   $HOME/.local/bin/apple-music-mcp setup --token "<user-token>"
   ```
- Browser helper mode (local server + MusicKit flow):
   ```bash
   APPLE_MUSIC_TEAM_ID="<team>" \
   APPLE_MUSIC_MUSICKIT_ID="<kid>" \
   APPLE_MUSIC_PRIVATE_KEY="$(cat /path/to/AuthKey.p8)" \
   swift run apple-music-mcp setup --serve --port 3000
   # Using the installed binary
   APPLE_MUSIC_TEAM_ID="<team>" \
   APPLE_MUSIC_MUSICKIT_ID="<kid>" \
   APPLE_MUSIC_PRIVATE_KEY="$(cat /path/to/AuthKey.p8)" \
   $HOME/.local/bin/apple-music-mcp setup --serve --port 3000
   ```
   This opens your default browser (via `open` on macOS or `xdg-open` if available on Linux) for Apple Music authorization and writes `~/Library/Application Support/apple-music-mcp/config.json` with `0600` permissions once the token is received (including team ID, MusicKit ID, and private key if available from env).
- Alternatively, place an existing user token in that config file if you already have one.

### Running the server
- Using source (dev workflow):
   ```bash
   swift run apple-music-mcp
   ```
- Using installed binary (after `install.sh` or manual install):
   ```bash
   $HOME/.local/bin/apple-music-mcp
   ```
Both commands read `~/Library/Application Support/apple-music-mcp/config.json` (or the file passed via `--config`) and ignore environment variables at runtime.

## Tests
From the Swift package directory (repo root):
```bash
swift test
```

## Endpoint to Tool Mapping

| Endpoint | Tool |
| --- | --- |
| GET /v1/catalog/{storefront}/search | search_catalog |
| GET /v1/catalog/{storefront}/search/suggestions | get_search_suggestions |
| GET /v1/catalog/{storefront}/songs | get_catalog_songs |
| GET /v1/catalog/{storefront}/albums | get_catalog_albums |
| GET /v1/catalog/{storefront}/artists | get_catalog_artists |
| GET /v1/catalog/{storefront}/playlists | get_catalog_playlists |
| GET /v1/catalog/{storefront}/curators | get_curators |
| GET /v1/catalog/{storefront}/radio-shows | get_radio_shows |
| GET /v1/catalog/{storefront}/music-videos | get_music_videos |
| GET /v1/catalog/{storefront}/genres | get_genres |
| GET /v1/catalog/{storefront}/stations | get_stations |
| GET /v1/catalog/{storefront}/charts | get_charts |
| GET /v1/catalog/{storefront}/activities | get_activities |
| GET /v1/catalog/{storefront}/record-labels | get_record_labels |
| GET /v1/catalog/{storefront}/{type} | get_catalog_resources |
| GET /v1/me/library/playlists | get_library_playlists |
| GET /v1/me/library/songs | get_library_songs |
| GET /v1/me/library/albums | get_library_albums |
| GET /v1/me/library/artists | get_library_artists |
| GET /v1/me/library/{type} | get_library_resources |
| GET /v1/me/recent/played | get_recently_played |
| GET /v1/me/recommendations | get_recommendations |
| GET /v1/me/replay/{year} | get_replay |
| POST /v1/me/library/playlists | create_playlist |
| POST /v1/me/library/playlists/{playlistId}/tracks | add_playlist_tracks |
| POST /v1/me/library/songs | add_library_songs |
| POST /v1/me/library/albums | add_library_albums |
| POST /v1/me/favorites/{resourceType} | add_favorites |
| GET /v1/me/storefront | get_user_storefront |
| GET /v1/{endpoint} (passthrough) | generic_get |

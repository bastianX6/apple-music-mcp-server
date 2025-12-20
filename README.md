# Apple Music MCP Server (Swift)

A macOS-only MCP server that exposes Apple Music API operations (catalog, library, recommendations, playlist management, and utility passthrough) over STDIO using the MCP Swift SDK.

## Installation

### Using compile.sh (recommended)
- From the repo root, run (current layout):
   ```bash
   bash swift/compile.sh
   ```
   Once the Swift sources live at the repo root, use:
   ```bash
   bash ./compile.sh
   ```
- The script builds `AppleMusicMCPServer` in release.
- It installs the server binary to `$HOME/.mcp/AppleMusicMCPServer/bin/AppleMusicMCPServer` (directory is created if missing).

### Manual installation (source-based)
1) From the Swift package directory (current: `swift`, future: repo root), build in release:
   ```bash
   swift build -c release --product AppleMusicMCPServer
   ```
2) Copy the server binary to your MCP bin path:
   ```bash
   mkdir -p "$HOME/.mcp/AppleMusicMCPServer/bin"
   install -m 755 .build/release/AppleMusicMCPServer "$HOME/.mcp/AppleMusicMCPServer/bin/AppleMusicMCPServer"
   ```

## Configuration

### Required environment variables (developer token only)
- `APPLE_MUSIC_TEAM_ID`
- `APPLE_MUSIC_MUSICKIT_ID` (or legacy `APPLE_MUSIC_MUSICKIT_KEY_ID`)
- One of `APPLE_MUSIC_PRIVATE_KEY_P8` or `APPLE_MUSIC_PRIVATE_KEY` (contents) or `APPLE_MUSIC_PRIVATE_KEY_PATH` (path to .p8)

User token is loaded exclusively from the config file written by `setup`; `APPLE_MUSIC_USER_TOKEN` is ignored.

### User token setup
- CLI mode (persist an existing token):
   ```bash
   swift run AppleMusicMCPServer setup --token "<user-token>"
   # Using the installed binary
   $HOME/.mcp/AppleMusicMCPServer/bin/AppleMusicMCPServer setup --token "<user-token>"
   ```
- Browser helper mode (local server + MusicKit flow):
   ```bash
   swift run AppleMusicMCPServer setup --serve --port 3000
   # Using the installed binary
   $HOME/.mcp/AppleMusicMCPServer/bin/AppleMusicMCPServer setup --serve --port 3000
   ```
   This opens your default browser for Apple Music authorization and writes `~/.mcp/AppleMusicMCPServer/configs/config.json` with `0600` permissions once the token is received.
- Alternatively, place an existing user token in that config file if you already have one.

### Running the server
- Using source (dev workflow):
   ```bash
   APPLE_MUSIC_TEAM_ID="<team>" \
   APPLE_MUSIC_MUSICKIT_ID="<kid>" \
   APPLE_MUSIC_PRIVATE_KEY_PATH="/path/to/AuthKey.p8" \
   swift run AppleMusicMCPServer
   ```
- Using installed binary (after `compile.sh` or manual install):
   ```bash
   APPLE_MUSIC_TEAM_ID="<team>" \
   APPLE_MUSIC_MUSICKIT_ID="<kid>" \
   APPLE_MUSIC_PRIVATE_KEY_PATH="/path/to/AuthKey.p8" \
   $HOME/.mcp/AppleMusicMCPServer/bin/AppleMusicMCPServer
   ```

## Tests
From this `swift` directory:
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

# AGENTS GUIDE

## What this project is
- Apple Music MCP server implemented in Swift (mirrors a TypeScript version) exposing Apple Music API tools via MCP.
- Uses Developer Token + Music User Token to access catalog and user endpoints.

## How to run
- Build from `swift/`: `sh ./install.sh` (outputs to `~/.local/bin/apple-music-mcp`).
- VS Code mcp.json points to that binary (stdio server).
- Always run `apple-music-mcp setup` first; it writes `~/Library/Application Support/apple-music-mcp/config.json` (or `--config <path>`).
- `setup` requires the following env vars at invocation time: `APPLE_MUSIC_TEAM_ID`, `APPLE_MUSIC_MUSICKIT_ID`, `APPLE_MUSIC_PRIVATE_KEY`.
- Runtime reads only from the config file; environment variables are ignored once the server starts.

## Key behaviors / limitations
- Library read endpoints work (playlists, songs, albums, artists, recently played, recommendations, heavy rotation).
- Catalog lookups and search work (songs, albums, artists, playlists, genres, charts, music videos, stations).
- Write limits: add-to-library and favorites return HTTP 405 (Apple restriction).
- Replay/"top listened" endpoints do not exist; use recently played as approximation only.
- Region-dependent: default to user storefront when available; otherwise `us`.

## Token handling
- Developer token is ES256 JWT signed with the provided `.p8` key; code normalizes inline keys with or without newlines.
- User token must come from client-side MusicKit JS or other authorized flow.

## Code map (swift/)
- `Sources/AppleMusicMCPServer/Auth`: token providers, errors.
- `Sources/AppleMusicMCPServer/HTTP`: AppleMusicClient, models, pagination helpers.
- `Sources/AppleMusicMCPServer/Setup`: setup helper/server.
- `Sources/AppleMusicMCPServer/Tools`: MCP tool registry (catalog, library, register, utility).
- `docs/`: API limitations and endpoint reference.

## Testing
- SwiftPM tests under `Tests/AppleMusicMCPServerTests/`.

## Safety notes for LLMs
- Never commit secrets (p8 keys, tokens). Accept one-line or multiline PEMs when constructing dev tokens.
- Surface Apple API 404/405 limits clearly; do not retry endlessly.

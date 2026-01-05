# AGENTS GUIDE

## What this project is
- Apple Music MCP server implemented in Swift (based on a TypeScript version) exposing Apple Music API tools via MCP.
- Parity CLI (`apple-music-tool`) with one subcommand per MCP tool (kebab-case) for local terminal use.
- Hybrid tool surface for full endpoint coverage (see `docs/hybrid_tool_spec.md`).
- Uses Developer Token + Music User Token to access catalog and user endpoints.

## How to run
- Build from repo root: `sh ./install.sh` (installs `apple-music-mcp` and `apple-music-tool` to `~/.local/bin`).
- VS Code mcp.json points to the MCP binary (stdio server).
- Always run `setup` first (either binary). Config paths:
  - MCP: `~/Library/Application Support/apple-music-mcp/config.json`
  - CLI: `~/Library/Application Support/apple-music-tool/config.json`
- `setup` requires env vars at invocation: `APPLE_MUSIC_TEAM_ID`, `APPLE_MUSIC_MUSICKIT_ID`, `APPLE_MUSIC_PRIVATE_KEY`.
- Runtime reads only from the config file; environment variables are ignored once the process starts.
- CLI usage: `swift run apple-music-tool <subcommand>` for dev, or installed binary for daily use. See `docs/tool_cli_overview.md` and `docs/tool_cli_reference.md` for subcommands/params.

## Key behaviors / limitations
- Library read endpoints work (playlists, songs, albums, artists, recently played, recommendations, heavy rotation).
- Catalog lookups and search work (songs, albums, artists, playlists, genres, charts, music videos, stations).
- Write limits: add-to-library and favorites often return HTTP 405 (Apple restriction).
- Replay data uses `/v1/me/music-summaries` but availability varies; fall back to recent playback when missing.
- Record labels and radio-show relationships are documented but often return 404/empty; treat as best-effort.
- Region-dependent: default to user storefront when available; otherwise `us`.

## Token handling
- Developer token is ES256 JWT signed with the provided `.p8` key; code normalizes inline keys with or without newlines.
- User token must come from client-side MusicKit JS or other authorized flow.

## Code map (swift/)
- `Sources/AppleMusicMCPServer/Auth`: token providers, errors.
- `Sources/AppleMusicMCPServer/HTTP`: AppleMusicClient, models, pagination helpers.
- `Sources/AppleMusicMCPServer/Setup`: setup helper/server.
- `Sources/AppleMusicMCPServer/Tools`: MCP tool registry (catalog, library, register, utility).
- `Sources/AppleMusicTool`: CLI entrypoint, ToolRunner, subcommands.
- `docs/`: hybrid tool specs, endpoint mapping, API limitations, CLI parity docs (`tool_cli_*`, `hybrid_tool_cli_smoke_prompts.md`).

## Testing
- SwiftPM tests under `Tests/AppleMusicMCPServerTests/`.
- Always run tests using `swift test --disable-sandbox` (confirmed working).
- Note: `swift --disable-sandbox test` is not a valid invocation.

## Safety notes for LLMs
- Never commit secrets (p8 keys, tokens). Accept one-line or multiline PEMs when constructing dev tokens.
- Surface Apple API 404/405 limits clearly; do not retry endlessly.

# `apple-music-tool` — Implementation Checklist

This checklist breaks down the work required to add the `apple-music-tool` CLI and migrate each MCP tool into a CLI subcommand.

## Global Tasks
- [ ] Add SwiftPM executable product: `apple-music-tool`
- [ ] Create new executable target sources under `Sources/AppleMusicTool/`
- [ ] Ensure `apple-music-tool` has no default subcommand (running without args should fail except `--help`)
- [ ] Use kebab-case subcommands (derive from tool name by replacing `_` → `-`)
- [ ] Implement global options:
  - [ ] `--config <path>` (default: `~/Library/Application Support/apple-music-tool/config.json`)
  - [ ] `--beautify`
- [ ] Implement JSON output:
  - [ ] Minified JSON by default
  - [ ] Pretty-printed JSON when `--beautify` is set
  - [ ] For non-2xx responses, emit standardized error JSON envelope (with raw Apple body under `details`) and exit non-zero
- [ ] Implement storefront behavior parity (resolve user storefront when user token exists)
- [ ] Implement file logging under `~/Library/Application Support/apple-music-tool/logs/`
- [ ] Update build/install scripts (optional but recommended):
  - [ ] Build and install `apple-music-tool` alongside `apple-music-mcp`

## Shared Library Refactor (to avoid duplication)
- [ ] Extract shared code into a library target (name TBD; e.g., `AppleMusicCore`):
  - [ ] Auth (Developer token, User token providers)
  - [ ] Config loader + config model
  - [ ] HTTP client (`AppleMusicClient`)
  - [ ] Storefront resolver
  - [ ] Setup helper/coordinator/server (parameterized for app name + config path)
- [ ] Make both executables depend on the shared library
- [ ] Ensure `setup` behavior is identical except for default app paths

## Tool Subcommand Checklists

> For each tool below, implement a CLI subcommand that:
> - accepts the same required/optional parameters
> - performs the same request
> - prints only the API JSON response (minified by default)
> - enforces auth requirements (user token where required)

### Catalog / Utility
- [ ] `get-user-storefront`
- [ ] `search-catalog`
- [ ] `get-search-hints`
- [ ] `get-search-suggestions`
- [ ] `get-charts`
- [ ] `get-genres`
- [ ] `get-stations`
- [ ] `get-catalog-songs`
- [ ] `get-catalog-albums`
- [ ] `get-catalog-artists`
- [ ] `get-catalog-playlists`
- [ ] `get-music-videos`
- [ ] `get-curators`
- [ ] `get-activities`
- [ ] `get-catalog-resources`
- [ ] `get-catalog-resource`
- [ ] `get-catalog-relationship`
- [ ] `get-catalog-view`
- [ ] `get-catalog-multi-by-type-ids`
- [ ] `get-best-language-tag`

### Unsupported / Informational
- [ ] `get-record-labels` (no request; standardized error JSON)
- [ ] `get-radio-shows` (no request; standardized error JSON)
- [ ] `get-replay` (no request; standardized error JSON)

### Library (Read)
- [ ] `get-library-playlists`
- [ ] `get-library-songs`
- [ ] `get-library-albums`
- [ ] `get-library-artists`
- [ ] `get-library-resources`
- [ ] `get-library-resource`
- [ ] `get-library-relationship`
- [ ] `get-library-multi-by-type-ids`
- [ ] `library-search`
- [ ] `get-library-recently-added`
- [ ] `get-recently-played`
- [ ] `get-recently-played-tracks`
- [ ] `get-recently-played-stations`
- [ ] `get-recommendations`
- [ ] `get-recommendation`
- [ ] `get-recommendation-relationship`
- [ ] `get-heavy-rotation`
- [ ] `get-replay-data`

### Library (Write) / Playlist Management
- [ ] `create-playlist`
- [ ] `add-playlist-tracks`
- [ ] `create-playlist-folder`
- [ ] `add-library-resources`
- [ ] `add-library-songs` (note: often 405)
- [ ] `add-library-albums` (note: often 405)
- [ ] `add-favorites` (note: often 405)
- [ ] `set-rating`
- [ ] `delete-rating`

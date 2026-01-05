# `apple-music-tool` — CLI Migration Proposal

This document proposes how to migrate the existing MCP tool surface into a standalone CLI executable named **`apple-music-tool`**.

## Goals
- Add a new SwiftPM executable product: **`apple-music-tool`** (separate from `apple-music-mcp`).
- Provide a **`setup`** subcommand identical in behavior to `apple-music-mcp setup`, except:
  - Default config location: `~/Library/Application Support/apple-music-tool/config.json`
  - Default logs location: `~/Library/Application Support/apple-music-tool/` (see Logging section)
- Provide **one subcommand per MCP tool** (parity with the MCP tool list).
- Print **only the Apple Music API JSON body** to stdout:
  - Minified JSON by default.
  - `--beautify` flag to pretty-print JSON.
- Disallow running without a subcommand (except `--help`).

## See also
- `docs/tool_migration/mcp_tools_guide.md:1` (current MCP tool surface)
- `docs/hybrid_tool_spec.md:1` (rationale and endpoint coverage model)
- `docs/hybrid_tool_endpoint_mapping.md:1` (endpoint ↔ tool mapping)
- `docs/configuration.md:1` and `docs/apple_music_api_auth_guide.md:1` (tokens + config rules)

## Proposed Command Layout

### Top-level
```
apple-music-tool <subcommand> [options]
```

### Global options (recommended)
- `--config <path>`: override config file path (default: `~/Library/Application Support/apple-music-tool/config.json`)
- `--beautify`: pretty-print JSON (default: false)

> Rationale: every endpoint needs config to build tokens; `--beautify` should apply everywhere.

## Subcommand Naming

### Required: kebab-case
CLI subcommands MUST be **kebab-case**, derived from the MCP tool names by replacing `_` with `-`.

Examples:
- MCP `search_catalog` → CLI `search-catalog`
- MCP `get_library_playlists` → CLI `get-library-playlists`
- MCP `add_favorites` → CLI `add-favorites`

This keeps the mapping deterministic and allows reliable, automated conversions.

> The MCP tool surface remains snake_case; only the CLI surface is kebab-case.

## Parameter Mapping (Tool → CLI)

### General rules
- Every MCP tool parameter becomes a CLI option named `--<param>`.
  - Example: MCP `term` → CLI `--term`.
- Required parameters are enforced by the CLI parser.
- Optional parameters default to the same defaults used by the current handlers (limits, offsets, default `types`, etc.).
- Parameters with bracket notation are mapped to kebab-case flags:
  - MCP `filter[year]` → CLI `--filter-year`
  - MCP `filter[identity]` → CLI `--filter-identity`
- Comma-separated lists remain comma-separated strings unless stated otherwise.

### Typed `ids` objects (multi-resource endpoints)
Some tools accept `ids` as an object keyed by resource type (e.g., `{"songs": "1,2"}`).

**Proposed CLI format:** repeatable `--ids <key>=<csv>` options.

Examples:
```
apple-music-tool get-catalog-multi-by-type-ids \
  --ids songs=203709340 \
  --ids albums=310730204
```

For tools that allow `ids` to be a string plus `resourceType`, keep parity:
```
apple-music-tool add-favorites \
  --ids 203709340,203709341 \
  --resourceType songs
```

**Reliability requirements**
- Parse `--ids` values by splitting on the **first** `=` character only.
- Preserve the original key casing as given (keys are expected to match Apple Music API types).
- When generating query parameters, sort keys to ensure deterministic output (useful for tests and reproducibility).

## Output Contract

### Success (2xx)
- Print the **response body JSON** from Apple Music API to stdout.
- Minified by default; pretty-printed when `--beautify` is provided.

### Apple Music API failures (non-2xx)
- Print a **standardized error JSON envelope** to stdout, honoring `--beautify`.
- Exit with a non-zero status code.

### Tool-level unsupported endpoints (no request)
- Print a **standardized error JSON envelope** to stdout, honoring `--beautify`.
- Exit with a non-zero status code.

### Local failures (missing config, missing tokens, invalid CLI args)
- Print a human-readable message to stderr.
- Exit with a non-zero status code.
- Stdout should remain empty (to keep stdout machine-parseable as JSON when present).

## Standard Error JSON Envelope
All CLI subcommands that fail after contacting Apple Music API MUST emit a standardized structure:

```json
{
  "error": {
    "type": "apple-music-api",
    "message": "Apple Music API returned status 401: ...",
    "status": 401,
    "details": {
      "appleMusicResponse": { "errors": [/* raw Apple error JSON */] }
    }
  }
}
```

Notes:
- `error.type` should be stable across the CLI (e.g., `apple-music-api`, `unsupported`).
- `details` is reserved for fields that may vary in structure (raw Apple error payload, request metadata, etc.).
- If Apple returns a non-JSON body, store it under `details.appleMusicResponseRaw` as a string.

## Storefront Behavior
Match existing server behavior:
- If a `Music-User-Token` exists, resolve the user storefront and **ignore** any `--storefront` override.
- Otherwise, default to `us` unless `--storefront` is specified.

## Logging
The CLI MUST write logs to disk.

**Proposal (default)**
- Log directory: `~/Library/Application Support/apple-music-tool/logs/`
- Log file: `apple-music-tool.log`
- Log format: line-oriented text (timestamp + level + message)
- Stdout must remain reserved for JSON output only.

## Subcommand List (Parity)
The CLI should include subcommands matching the MCP tools (kebab-case), excluding `generic-get`.

- `get-user-storefront`
- `search-catalog`
- `get-search-hints`
- `get-search-suggestions`
- `get-charts`
- `get-genres`
- `get-stations`
- `get-catalog-songs`
- `get-catalog-albums`
- `get-catalog-artists`
- `get-catalog-playlists`
- `get-music-videos`
- `get-curators`
- `get-activities`
- `get-catalog-resources`
- `get-catalog-resource`
- `get-catalog-relationship`
- `get-catalog-view`
- `get-catalog-multi-by-type-ids`
- `get-best-language-tag`
- `get-record-labels` (informative error; no request)
- `get-radio-shows` (informative error; no request)
- `get-library-playlists`
- `get-library-songs`
- `get-library-albums`
- `get-library-artists`
- `get-library-resources`
- `get-library-resource`
- `get-library-relationship`
- `get-library-multi-by-type-ids`
- `library-search`
- `get-library-recently-added`
- `get-recently-played`
- `get-recently-played-tracks`
- `get-recently-played-stations`
- `get-recommendations`
- `get-recommendation`
- `get-recommendation-relationship`
- `get-heavy-rotation`
- `get-replay-data`
- `get-replay` (informative error; no request)
- `create-playlist`
- `add-playlist-tracks`
- `create-playlist-folder`
- `add-library-resources`
- `add-library-songs`
- `add-library-albums`
- `add-favorites`
- `set-rating`
- `delete-rating`

Explicitly excluded:
- `generic-get` (intentionally not provided by the CLI)

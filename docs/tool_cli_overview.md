# apple-music-tool — CLI Reference & Overview

This document is the source of truth for the CLI surface that mirrors the MCP tools. It combines the earlier proposal and tool guide into a single reference for engineers and LLMs.

## Goals
- Standalone SwiftPM executable: `apple-music-tool` (kebab-case subcommands).
- One subcommand per MCP tool (excluding `generic_get`).
- Output: Apple Music API JSON to stdout (minified by default; `--beautify` pretty-prints). Errors use a standardized JSON envelope and non-zero exit code.
- Config/log paths default to `~/Library/Application Support/apple-music-tool/`.

## Global options
- `--config <path>`: override config file path (default: `~/Library/Application Support/apple-music-tool/config.json`).
- `--beautify`: pretty-print JSON output.

## Parameter mapping rules
- CLI flag is `--<param>` for each MCP parameter.
- Bracket params become kebab: `filter[year]` → `--filter-year`.
- Comma-separated lists stay strings.
- Typed `ids` objects use repeatable `--ids key=value` flags (split on first `=`). For tools that also accept CSV + `resourceType`, support both forms.

## Storefront behavior
- With user token: resolve storefront; ignore `--storefront` override.
- Without user token: default `us` unless `--storefront` provided.

## Error envelope (CLI)
```json
{
  "error": {
    "type": "apple-music-api|unsupported|tool-error",
    "message": "...",
    "status": 401,
    "details": {"appleMusicResponse": {"errors": []}}
  }
}
```
Failing commands write envelope to stderr and exit non-zero.

## Subcommand list (parity with MCP)
- get-user-storefront
- search-catalog
- get-search-hints
- get-search-suggestions
- get-charts
- get-genres
- get-stations
- get-activities
- get-catalog-songs
- get-catalog-albums
- get-catalog-artists
- get-catalog-playlists
- get-music-videos
- get-curators
- get-catalog-resources
- get-catalog-resource
- get-catalog-relationship
- get-catalog-view
- get-catalog-multi-by-type-ids
- get-best-language-tag
- get-library-playlists
- get-library-songs
- get-library-albums
- get-library-artists
- get-library-resources
- get-library-resource
- get-library-relationship
- get-library-multi-by-type-ids
- library-search
- get-library-recently-added
- get-recently-played
- get-recently-played-tracks
- get-recently-played-stations
- get-recommendations
- get-recommendation
- get-recommendation-relationship
- get-heavy-rotation
- get-replay-data
- get-replay
- create-playlist
- add-playlist-tracks
- create-playlist-folder
- add-library-resources
- add-library-songs
- add-library-albums
- add-favorites
- set-rating
- delete-rating

## See also
- docs/tool_cli_reference.md — detailed parameter tables and behaviors.
- docs/hybrid_tool_spec.md — hybrid model principles.
- docs/hybrid_tool_endpoint_mapping.md — endpoint ↔ tool mapping.
- docs/API_LIMITATIONS.md — known Apple API constraints (405/404/region).

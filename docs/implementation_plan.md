# Apple Music MCP Server Implementation Plan

## Purpose
Provide a complete blueprint for a Node.js MCP server that exposes Apple Music API capabilities to LLM clients via MCP tools. Serves as a handoff document for implementers and other LLMs.

## Goals
- Support both catalog (developer token) and user library (user token) operations.
- Ship as an `npx`-runnable package with STDIO transport for MCP.
- Offer clear file layout, responsibilities, and tool definitions mapped to Apple Music endpoints.
- Include auth flows, configuration, error handling, testing, and release guidance.

## Non-Goals
- Implement UI beyond the OAuth setup page for MusicKit.
- Provide production observability stack (logs/metrics tracing beyond basic logging).

## High-Level Architecture
- **Runtime**: Node.js (TypeScript preferred), ESM.
- **Transport**: MCP STDIO via `@modelcontextprotocol/sdk`.
- **Auth**: Dual-token (Developer Token server-side JWT, User Token via browser-based MusicKit authorization).
- **API Layer**: Thin HTTP client to `https://api.music.apple.com`, developer token for catalog, user token for `/v1/me/*`.
- **Tools Layer**: MCP tools grouped by domain (search, catalog, library, recommendations, management, utility).
- **Config**: Env vars + `~/.config/apple-music-mcp/config.json` (0600 perms).

## Directory & File Plan
```
apple-music-mcp-server/
├─ package.json            # name, bin, deps, scripts, type=module
├─ tsconfig.json           # ES2022, strict, outDir=dist, rootDir=src
├─ .gitignore              # node_modules, dist, .env, *.p8, config, coverage
├─ .npmignore              # include dist/, bin/, exclude tests, docs if desired
├─ README.md               # usage, config, tools list
├─ LICENSE                 # MIT or chosen
├─ bin/
│  ├─ apple-music-mcp       # #!/usr/bin/env node → ../dist/index.js
│  └─ apple-music-mcp-setup # #!/usr/bin/env node → ../dist/setup.js
├─ src/
│  ├─ index.ts              # entry: load config, init auth, init client, start server
│  ├─ setup.ts              # CLI OAuth flow (Express + MusicKit page + callback)
│  ├─ server/
│  │  ├─ server.ts          # create McpServer, declare capabilities, connect transport
│  │  └─ tools.ts           # orchestrates registration of all tool modules
│  ├─ auth/
│  │  ├─ developer-token.ts # ES256 JWT generation, caching, renewal window
│  │  ├─ user-token.ts      # load/validate user token
│  │  └─ config.ts          # ConfigManager: load/save file, merge env, ensure 0600
│  ├─ api/
│  │  ├─ client.ts          # AppleMusicClient: GET/POST with token injection, errors
│  │  ├─ catalog/           # wrappers for catalog endpoints (dev token)
│  │  │  ├─ search.ts
│  │  │  ├─ songs.ts
│  │  │  ├─ albums.ts
│  │  │  ├─ artists.ts
│  │  │  ├─ playlists.ts
│  │  │  └─ charts.ts
│  │  └─ library/           # wrappers for user endpoints (user token)
│  │     ├─ playlists.ts
│  │     ├─ songs.ts
│  │     ├─ albums.ts
│  │     └─ recommendations.ts
│  ├─ tools/
│  │  ├─ search-tools.ts          # search_catalog, get_search_suggestions
│  │  ├─ catalog-tools.ts         # get_catalog_{songs,albums,artists,playlists,charts,...}
│  │  ├─ library-tools.ts         # get_library_{playlists,songs,albums,artists}, get_recently_played
│  │  ├─ recommendation-tools.ts  # get_recommendations, get_replay_data
│  │  └─ management-tools.ts      # add_songs_to_library, add_albums_to_library, create_playlist, add_items_to_playlist, add_to_favorites
│  └─ types/
│     ├─ apple-music.ts     # response interfaces
│     └─ mcp.ts             # MCP tool schemas/types
└─ docs/
   ├─ apple_music_api_auth_guide.md
   ├─ apple_music_api_endpoints.md
   └─ apple_music_api_investigation.md
```

## Authentication Flows
- **Developer Token (server-managed)**: JWT ES256 signed with P8 key; claims: `iss`=Team ID, `kid`=MusicKit ID, expiration ~6 months; cache in memory; auto-renew when <30 days remaining.
- **User Token (user-provided)**: Obtained via CLI setup:
  1) `npx apple-music-mcp-setup` starts local Express server on 127.0.0.1:3000.
  2) Opens browser with MusicKit for Web page.
  3) User authorizes; musicUserToken posted back to `/callback`.
  4) Token saved to `~/.config/apple-music-mcp/config.json` with 0600 perms.
- **Config precedence**: env vars override file. Env keys: `APPLE_MUSIC_PRIVATE_KEY`, `APPLE_MUSIC_TEAM_ID`, `APPLE_MUSIC_MUSICKIT_ID`, `APPLE_MUSIC_USER_TOKEN`.

## MCP Tools Mapping (30 endpoints)
- **Search & Discovery (Dev Token)**: `search_catalog`, `get_search_suggestions`, `get_charts`, `get_activities`.
- **Catalog (Dev Token)**: `get_catalog_songs`, `get_catalog_albums`, `get_catalog_artists`, `get_catalog_playlists`, `get_music_videos`, `get_genres`, `get_curators`, `get_radio_shows`, `get_stations`, `get_record_labels`, `get_multiple_resources`, `generic_request` (dev/user based on path).
- **Library Read (User Token)**: `get_library_playlists`, `get_library_songs`, `get_library_albums`, `get_library_artists`, `get_recently_played`, `get_user_storefront`.
- **Recommendations (User Token)**: `get_recommendations`, `get_replay_data`.
- **Library Management (User Token)**: `add_songs_to_library`, `add_albums_to_library`, `add_items_to_playlist`, `create_playlist`, `add_to_favorites`.

## Tool Design Guidelines
- Use `zod` for input/output schemas; provide defaults (storefront="us", limit caps).
- Add annotations: `readOnlyHint` true for GET tools, `idempotentHint` true where safe, `destructiveHint` false for all.
- Outputs: `content` as pretty JSON text; `structuredContent` with typed object.
- Error handling: map HTTP errors to friendly messages; include status code and Apple error payload.

## Apple Music Client Behavior
- Base URL: `https://api.music.apple.com`.
- Headers: `Authorization: Bearer <developerToken>`; `Music-User-Token: <userToken>` when required.
- Retries: optional backoff for 429; surface 401/403 with guidance (renew tokens / run setup).
- Pagination: support `offset`/`limit` parameters when exposed by tools.

## Setup CLI (setup.ts)
- Express server + static HTML with MusicKit JS SDK.
- Inject current Developer Token into page config (generated on the fly).
- POST callback persists user token and exits process after success message.
- Ensure only localhost binding; log URL; auto-open browser with `open`.

## Implementation Phases
- **Phase 1 (MVP)**: `search_catalog`, `get_catalog_songs`, `get_catalog_albums`, `get_library_playlists`, `get_library_songs`; implement auth managers, config, setup CLI, server bootstrap.
- **Phase 2 (Core)**: add remaining read tools (artists, playlists, recently played, recommendations, storefront, suggestions, charts).
- **Phase 3 (Full)**: add management tools and lesser-used catalog endpoints; add generic request tool.
- **Phase 4 (Polish)**: caching, retries, richer logging, docs, examples, NPM publish.

## Configuration & Security
- Never commit P8 keys or tokens; ignore via .gitignore.
- Enforce 0600 on config file writes.
- Validate presence of developer credentials on startup; if missing, exit with instructions.
- For user-token-required tools, return clear error prompting `npx apple-music-mcp-setup`.

## Error Handling Strategy
- Wrap tool handlers with try/catch; return `isError: true` with concise message.
- Parse Apple Music error responses; surface `status`, `title`, `detail`.
- Rate limits: optional exponential backoff; otherwise bubble 429 with retry-after if present.

## Testing Plan
- Unit: auth (developer-token expiry/renewal), config load/merge, client header injection, tool schema validation.
- Integration: setup flow with mocked MusicKit callback; server start + sample tool call with mocked fetch.
- E2E (optional): live API smoke (gated by env vars) in CI nightly.
- Framework: Vitest; ts-node/tsx for test runner if needed.

## Build & Distribution
- Scripts: `build` (tsc), `dev` (tsx src/index.ts), `setup` (tsx src/setup.ts), `test` (vitest), `prepare` (npm run build).
- Bin entries: `apple-music-mcp` → dist/index.js; `apple-music-mcp-setup` → dist/setup.js (both chmod +x in publish pipeline).
- Publish: `npm publish --access public`; consumers run via `npx -y <pkg>` in MCP config.

## Open Questions (for implementers)
- Should storefront auto-detect via `GET /v1/me/storefront` and cache per session?
- Do we cache GET responses (short TTL) to reduce API calls and rate limits?
- Should generic_request allow method override (POST) or stay read-only for safety?
- Preferred logging format for MCP clients (structured JSON vs plaintext)?

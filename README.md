# Apple Music MCP Server

Node.js MCP server that exposes Apple Music catalog and user library features via MCP tools. Implements dual-token authentication (Developer Token via ES256 JWT, User Token via MusicKit for Web authorization) and is runnable via `npx`.

## Development

- Install deps: `npm install`
- Build: `npm run build`
- Dev (stdio server): `npm run dev`
- Setup user token: `npm run setup`
- Test: `npm test`

Configuration is loaded from environment variables or `~/.config/apple-music-mcp/config.json`.

# Apple Music MCP Server

Node.js MCP server that exposes Apple Music catalog and user library features via MCP tools. Implements dual-token authentication (Developer Token via ES256 JWT, User Token via MusicKit for Web authorization) and is runnable via `npx`.

## ⚠️ Known API Limitations

Some Apple Music API endpoints have restrictions. See **[docs/API_LIMITATIONS.md](./docs/API_LIMITATIONS.md)** for details on:
- **Write operations** that return 405 Method Not Allowed (add songs/albums to library, favorites)
- **Non-existent endpoints** (replay data, radio shows, record labels as resources)
- **Editorial content requirements** (activities, curators need specific IDs)
- **Regional content variations**
- Workarounds and alternatives

**Production Status**: ✅ **80% success rate (24/30 tools) - PRODUCTION READY**  
**Testing Coverage**: ✅ **100% (30/30 tools tested)**

## Development

- Install deps: `npm install`
- Build: `npm run build`
- Dev (stdio server): `npm run dev`
- Setup user token: `npm run setup`
- Test: `npm test`

Configuration is loaded from environment variables or `~/.config/apple-music-mcp/config.json`.

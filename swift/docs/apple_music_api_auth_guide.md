# Apple Music API Authentication Guide (Swift MCP Server)

## Overview
The Swift MCP server needs two tokens:
- **Developer Token**: Server-generated ES256 JWT for catalog endpoints.
- **User Token**: User-granted token for `/v1/me/*` library and personalized endpoints.

The authentication model is language-agnostic; this guide describes how to implement it in Swift using Swift Package Manager on macOS.

## Developer Token

### Purpose
Access public catalog endpoints without user interaction.

### Required Credentials
- **Team ID** (Apple Developer)
- **MusicKit Key ID** (kid)
- **Private Key (.p8)** associated with the MusicKit key
- **Bundle Identifier** (registered with MusicKit capability)

### Swift Implementation
- Use **Swift JWT** (https://github.com/Kitura/Swift-JWT) or **CryptoKit** to sign ES256.
- Claims: `iss` = Team ID, `exp` ≈ now + 6 months (max), `iat` = now.
- Header: `alg` = ES256, `kid` = MusicKit Key ID, `typ` = JWT.
- Sign with the `.p8` private key loaded from disk or environment.
- Cache the token in memory; renew when <30 days from expiration.

### Configuration Inputs
- Environment variables (recommended for macOS CLI):
  - `APPLE_MUSIC_TEAM_ID`
  - `APPLE_MUSIC_MUSICKIT_KEY_ID`
  - `APPLE_MUSIC_PRIVATE_KEY_P8` (contents) **or** `APPLE_MUSIC_PRIVATE_KEY_PATH`
  - `APPLE_MUSIC_BUNDLE_ID` (for completeness)
- Local config file (user-only permissions 0600): `~/.mcp/AppleMusicMCPServer/configs/config.json`

### Delivery to Requests
- Include `Authorization: Bearer <developerToken>` on catalog requests.
- Do not attach the developer token to user endpoints without a user token (Apple will 401/403).

## User Token

### Purpose
Access personal library, recommendations, listening history, storefront detection, and other `/v1/me/*` endpoints.

### Why the Server Cannot Generate It
- Apple requires an interactive authorization step (MusicKit) with the user’s Apple ID.
- Tokens are issued only after user approval; no server-side flow exists.

### Acquisition Strategy (Recommended)
Use a helper tool that opens the default browser and leverages **MusicKit JS** for authorization, mirroring the TypeScript flow:
1) Start a local HTTP server on `127.0.0.1:<port>` (e.g., 3000).
2) Generate (or reuse) the current Developer Token to initialize MusicKit.
3) Serve a static HTML page that calls `MusicKit.configure` and triggers `authorize()`.
4) On success, MusicKit returns `musicUserToken`; POST it back to the local server.
5) Persist the token at `~/.mcp/AppleMusicMCPServer/configs/config.json` (0600 perms).
6) The Swift MCP server reads the token on startup.

### Implementation Options
- **Swift target** (`AppleMusicMCPSetup`):
  - Use SwiftNIO or a lightweight HTTP server (e.g., Vapor minimal, or URLSession-backed listener) to receive the callback.
  - Use `NSWorkspace.shared.open` to launch the browser (macOS-only).
  - Serve a static HTML page from `Resources/SetupPage` bundled in the package.
- **Reuse existing JS flow**: You may reuse the TypeScript CLI to produce the user token and point the Swift server to the same config file. Behavior is identical once the token exists.

### Configuration Inputs
- `APPLE_MUSIC_USER_TOKEN` env var (highest precedence)
- `~/.mcp/AppleMusicMCPServer/configs/config.json` (persisted by the integrated setup helper)

### Request Headers
- Attach `Music-User-Token: <userToken>` to all `/v1/me/*` and personalized endpoints.

## Recommended Server Authentication Architecture
1) **Config Loader**: Merge env vars and config file; enforce 0600 permissions on file writes.
2) **DeveloperTokenProvider**: Build and cache the ES256 JWT; expose expiration metadata for proactive renewal.
3) **UserTokenProvider**: Load token if present; expose clear errors when missing for user endpoints.
4) **Request Pipeline**: Choose headers per endpoint class (catalog vs library); never send a stale token.
5) **Validation & Errors**: Surface 401/403 with remediation tips ("Run setup to refresh user token", "Check private key").

## Setup Workflow (End Users)
1) Install the Swift server (SPM build or binary release for macOS).
2) Provide developer credentials via env or config file.
3) Run the setup helper to obtain a user token (opens browser, MusicKit auth).
4) Start the MCP server; it loads tokens and registers tools over STDIO.
5) Invoke tools from MCP clients with catalog + user endpoints available.

## Security Considerations
- Never commit `.p8` keys or tokens; keep them out of VCS.
- Restrict config file permissions to user-read/write only.
- Bind the setup HTTP server to `127.0.0.1` only; use random or configurable high ports.
- Avoid logging tokens; redact secrets in diagnostics.
- Handle token expiration gracefully; do not crash the MCP server on missing user tokens—return actionable errors.

## References
- Apple Music API: https://developer.apple.com/documentation/applemusicapi
- MusicKit JS authorization: https://developer.apple.com/documentation/musickitjs
- MCP Swift SDK: https://github.com/modelcontextprotocol/swift-sdk
- Swift JWT: https://github.com/Kitura/Swift-JWT

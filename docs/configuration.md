# Configuration format

The server always reads configuration from a single JSON file. Pass `--config /custom/path.json` to either `run` or `setup` to override the default location `~/Library/Application Support/apple-music-mcp/config.json`. Files must exist and have `0600` permissions; otherwise the server exits with an error instructing you to run `setup`.

The `setup` command still uses environment variables to build the JSON file. Missing env vars:

- `APPLE_MUSIC_TEAM_ID`
- `APPLE_MUSIC_MUSICKIT_ID`
- `APPLE_MUSIC_PRIVATE_KEY`

cause `setup` to fail immediately. The Music-User-Token is provided either via `--token` (CLI) or through the browser helper and then persisted into the same JSON file.

## Keys

| File key(s)            | Populated by setup from…     | Notes                              |
|------------------------|------------------------------|------------------------------------|
| `teamID` or `appleMusic.teamId` | APPLE_MUSIC_TEAM_ID env      | Required for developer token       |
| `musicKitKeyID` or `appleMusic.musicKitKeyId` | APPLE_MUSIC_MUSICKIT_ID env| Required for developer token       |
| `privateKey` or `appleMusic.privateKey`  | APPLE_MUSIC_PRIVATE_KEY env  | Required inline PEM                |
| `userToken` or `appleMusic.userToken`   | CLI `--token` or browser flow| Required for library endpoints     |

## Example JSON file

```json
{
  "teamID": "YOUR_TEAM_ID",
  "musicKitKeyID": "YOUR_MUSICKIT_ID",
  "privateKey": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----",
  "userToken": "optional-user-token"
}
```

This flat shape is what the Swift `setup` subcommand currently writes. The loader also accepts the nested `appleMusic.*` keys used by earlier tooling, so either structure works. No environment overrides exist at runtime—the JSON file is the single source of truth.

# Configuration format

The server reads configuration from environment variables first and then from an optional JSON file. You can pass the file path with `--config` or set `APPLE_MUSIC_CONFIG_PATH`. If neither is provided, the loader uses `~/Library/Application Support/apple-music-mcp/config.json`. Missing files are ignored; if present, the file must be `0600`.

## Keys

| File key (dot path)    | Environment variable        | Notes                              |
|------------------------|-----------------------------|------------------------------------|
| appleMusic.teamId      | APPLE_MUSIC_TEAM_ID         | Required for developer token       |
| appleMusic.musicKitKeyId | APPLE_MUSIC_MUSICKIT_ID   | Required for developer token       |
| appleMusic.privateKey  | APPLE_MUSIC_PRIVATE_KEY     | Required inline PEM                |
| appleMusic.userToken   | APPLE_MUSIC_USER_TOKEN      | Optional; normally written by setup|

## Example JSON file

```json
{
  "appleMusic": {
    "teamId": "YOUR_TEAM_ID",
    "musicKitKeyId": "YOUR_MUSICKIT_ID",
    "privateKey": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----",
    "userToken": "optional-user-token"
  }
}
```

Provider precedence: environment variables override the JSON file. Within the file, only present keys are used; empty or whitespace-only values are ignored.

Legacy flat JSON produced by earlier setup runs is still accepted for backward compatibility, but the nested structure above is preferred.

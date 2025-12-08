import express from 'express';
import open from 'open';
import path from 'path';
import { fileURLToPath } from 'url';
import { ConfigManager } from './auth/config.js';
import { DeveloperTokenManager } from './auth/developer-token.js';

const DEFAULT_PORT = 3000;

async function main(): Promise<void> {
  const configManager = new ConfigManager();
  const config = await configManager.load();
  const envConfig = configManager.loadFromEnv();
  const merged = {
    ...config,
    ...envConfig,
    developerToken: envConfig.developerToken ?? config.developerToken,
  };

  if (!merged.developerToken) {
    throw new Error(
      'Developer credentials missing. Set APPLE_MUSIC_PRIVATE_KEY, APPLE_MUSIC_TEAM_ID, APPLE_MUSIC_MUSICKIT_ID.',
    );
  }

  const developerTokenManager = new DeveloperTokenManager(merged.developerToken);
  const developerToken = await developerTokenManager.getToken();

  const app = express();
  app.use(express.json());

  app.get('/', (_req, res) => {
    res.send(renderAuthPage(developerToken));
  });

  app.post('/callback', async (req, res) => {
    const token = req.body?.userToken as string | undefined;
    if (!token) {
      res.status(400).json({ error: 'Missing userToken' });
      return;
    }

    const nextConfig = { ...merged, userToken: token, timestamp: new Date().toISOString() };
    await configManager.save(nextConfig);
    res.json({ success: true });
    setTimeout(() => process.exit(0), 500);
  });

  const port = Number(process.env.PORT || DEFAULT_PORT);
  const server = app.listen(port, '127.0.0.1', async () => {
    const url = `http://127.0.0.1:${port}`;
    console.log(`Opening browser for Apple Music authorization at ${url}`);
    await open(url);
  });

  ['SIGINT', 'SIGTERM'].forEach((signal) => {
    process.on(signal, () => {
      server.close(() => process.exit(0));
    });
  });
}

function renderAuthPage(developerToken: string): string {
  const __filename = fileURLToPath(import.meta.url);
  const buildId = path.basename(path.dirname(__filename));
  return `<!doctype html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Apple Music MCP Setup</title>
    <script src="https://js-cdn.music.apple.com/musickit/v3/musickit.js"></script>
  </head>
  <body>
    <h1>Connect Apple Music</h1>
    <button id="authorize">Authorize</button>
    <pre id="status"></pre>
    <script>
      document.addEventListener('musickitloaded', function () {
        MusicKit.configure({
          developerToken: '${developerToken}',
          app: { name: 'apple-music-mcp', build: '${buildId}' }
        });
        const button = document.getElementById('authorize');
        const status = document.getElementById('status');
        button.addEventListener('click', async () => {
          try {
            const music = MusicKit.getInstance();
            const userToken = await music.authorize();
            status.textContent = 'Authorized, saving token...';
            await fetch('/callback', {
              method: 'POST',
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify({ userToken })
            });
            status.textContent = 'Saved. You may close this window.';
          } catch (err) {
            status.textContent = 'Authorization failed: ' + err;
          }
        });
      });
    </script>
  </body>
</html>`;
}

main().catch((err) => {
  console.error(err instanceof Error ? err.message : err);
  process.exit(1);
});

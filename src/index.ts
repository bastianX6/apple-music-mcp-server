import { AppleMusicClient } from './api/client.js';
import { ConfigManager } from './auth/config.js';
import { DeveloperTokenManager } from './auth/developer-token.js';
import { UserTokenManager } from './auth/user-token.js';
import { startServer } from './server/server.js';

async function main(): Promise<void> {
  const configManager = new ConfigManager();
  const fileConfig = await configManager.load();
  const envConfig = configManager.loadFromEnv();
  const merged = {
    ...fileConfig,
    ...envConfig,
    developerToken: envConfig.developerToken ?? fileConfig.developerToken,
    userToken: envConfig.userToken ?? fileConfig.userToken,
  };

  if (!merged.developerToken) {
    throw new Error(
      'Developer credentials missing. Set APPLE_MUSIC_PRIVATE_KEY, APPLE_MUSIC_TEAM_ID, APPLE_MUSIC_MUSICKIT_ID.',
    );
  }

  const developerTokenManager = new DeveloperTokenManager(merged.developerToken);
  const userTokenManager = new UserTokenManager(merged);
  const client = new AppleMusicClient(developerTokenManager, userTokenManager);

  await startServer(client);
}

main().catch((err) => {
  console.error(err instanceof Error ? err.message : err);
  process.exit(1);
});

import fs from 'fs/promises';
import os from 'os';
import path from 'path';

export type DeveloperTokenConfig = {
  privateKey: string;
  teamId: string;
  keyId: string;
};

export type StoredConfig = {
  developerToken?: DeveloperTokenConfig;
  userToken?: string;
  timestamp?: string;
};

export class ConfigManager {
  private readonly configPath: string;

  constructor(configPath?: string) {
    this.configPath =
      configPath ?? path.join(os.homedir(), '.config', 'apple-music-mcp', 'config.json');
  }

  async load(): Promise<StoredConfig> {
    try {
      const raw = await fs.readFile(this.configPath, 'utf-8');
      return JSON.parse(raw) as StoredConfig;
    } catch {
      return {};
    }
  }

  async save(config: StoredConfig): Promise<void> {
    const dir = path.dirname(this.configPath);
    await fs.mkdir(dir, { recursive: true });
    const data = JSON.stringify(config, null, 2);
    await fs.writeFile(this.configPath, data, { mode: 0o600 });
  }

  loadFromEnv(): Partial<StoredConfig> {
    const privateKey = process.env.APPLE_MUSIC_PRIVATE_KEY;
    const teamId = process.env.APPLE_MUSIC_TEAM_ID;
    const keyId = process.env.APPLE_MUSIC_MUSICKIT_ID;
    const userToken = process.env.APPLE_MUSIC_USER_TOKEN;

    const developerToken = privateKey && teamId && keyId
      ? { privateKey, teamId, keyId }
      : undefined;

    return {
      developerToken,
      userToken: userToken || undefined,
    } satisfies Partial<StoredConfig>;
  }
}

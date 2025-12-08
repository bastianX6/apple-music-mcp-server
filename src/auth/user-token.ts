import { StoredConfig } from './config.js';

export class UserTokenManager {
  constructor(private readonly config: StoredConfig) {}

  getToken(): string | undefined {
    return this.config.userToken;
  }

  ensureTokenOrThrow(): string {
    const token = this.getToken();
    if (!token) {
      throw new Error('User token not configured. Run `npx apple-music-mcp-setup` to authorize.');
    }
    return token;
  }
}

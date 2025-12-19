import fetch, { Response } from 'node-fetch';
import { DeveloperTokenManager } from '../auth/developer-token.js';
import { UserTokenManager } from '../auth/user-token.js';

export class AppleMusicClient {
  constructor(
    private readonly developerTokenManager: DeveloperTokenManager,
    private readonly userTokenManager?: UserTokenManager,
  ) {}

  async get(endpoint: string, useUserToken = false): Promise<unknown> {
    const url = this.buildUrl(endpoint);
    const headers = await this.buildHeaders(useUserToken);
    const res = await fetch(url, { headers });
    await this.ensureOk(res);
    return res.json();
  }

  async post(endpoint: string, body: unknown, useUserToken = true): Promise<unknown> {
    const url = this.buildUrl(endpoint);
    const headers = await this.buildHeaders(useUserToken);
    const res = await fetch(url, {
      method: 'POST',
      headers: {
        ...headers,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(body),
    });
    await this.ensureOk(res);
    
    // Handle 204 No Content or empty responses
    const text = await res.text();
    if (!text) return { success: true };
    return JSON.parse(text);
  }

  private buildUrl(endpoint: string): string {
    const path = endpoint.startsWith('/') ? endpoint : `/${endpoint}`;
    return `https://api.music.apple.com${path}`;
  }

  private async buildHeaders(useUserToken: boolean): Promise<Record<string, string>> {
    const developerToken = await this.developerTokenManager.getToken();
    const base: Record<string, string> = {
      Authorization: `Bearer ${developerToken}`,
    };

    if (useUserToken) {
      const token = this.userTokenManager?.getToken();
      if (!token) {
        throw new Error('User token required. Run `npx apple-music-mcp-setup` first.');
      }
      base['Music-User-Token'] = token;
    }

    return base;
  }

  private async ensureOk(res: Response): Promise<void> {
    if (res.ok) return;
    let detail = '';
    try {
      const payload = await res.json();
      detail = JSON.stringify(payload);
    } catch {
      detail = res.statusText;
    }
    throw new Error(`Apple Music API error ${res.status}: ${detail}`);
  }
}

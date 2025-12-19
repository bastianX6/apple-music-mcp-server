import { importPKCS8, SignJWT } from 'jose';
import { DeveloperTokenConfig } from './config.js';

const SIX_MONTHS_SECONDS = 60 * 60 * 24 * 30 * 6;
const RENEWAL_BUFFER_SECONDS = 60 * 60 * 24 * 30; // 30 days

export class DeveloperTokenManager {
  private cachedToken: string | null = null;
  private expiresAt: number | null = null;

  constructor(private readonly config: DeveloperTokenConfig) {}

  async getToken(): Promise<string> {
    if (this.cachedToken && this.expiresAt && this.isValid()) {
      return this.cachedToken;
    }
    return this.generateToken();
  }

  private isValid(): boolean {
    if (!this.expiresAt) return false;
    const now = Math.floor(Date.now() / 1000);
    return this.expiresAt - RENEWAL_BUFFER_SECONDS > now;
  }

  private async generateToken(): Promise<string> {
    const pk = await importPKCS8(this.config.privateKey, 'ES256');
    const issuedAt = Math.floor(Date.now() / 1000);
    const expiresAt = issuedAt + SIX_MONTHS_SECONDS;

    const jwt = await new SignJWT({})
      .setProtectedHeader({ alg: 'ES256', kid: this.config.keyId })
      .setIssuer(this.config.teamId)
      .setIssuedAt(issuedAt)
      .setExpirationTime(expiresAt)
      .sign(pk);

    this.cachedToken = jwt;
    this.expiresAt = expiresAt;
    return jwt;
  }
}

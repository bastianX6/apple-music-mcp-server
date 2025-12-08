import { AppleMusicClient } from '../api/client.js';
import { registerCatalogTools } from '../tools/catalog-tools.js';
import { registerLibraryTools } from '../tools/library-tools.js';
import { registerManagementTools } from '../tools/management-tools.js';
import { registerRecommendationTools } from '../tools/recommendation-tools.js';
import { registerSearchTools } from '../tools/search-tools.js';
import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';

export function registerAllTools(server: McpServer, client: AppleMusicClient): void {
  registerSearchTools(server, client);
  registerCatalogTools(server, client);
  registerLibraryTools(server, client);
  registerRecommendationTools(server, client);
  registerManagementTools(server, client);
}

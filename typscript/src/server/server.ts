import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { AppleMusicClient } from '../api/client.js';
import { registerAllTools } from './tools.js';

export async function startServer(client: AppleMusicClient): Promise<void> {
  const server = new McpServer(
    {
      name: 'apple-music-mcp-server',
      version: '0.1.0',
    },
    {
      capabilities: {
        tools: {},
        logging: {},
      },
    },
  );

  registerAllTools(server, client);

  const transport = new StdioServerTransport();
  await server.connect(transport);
}

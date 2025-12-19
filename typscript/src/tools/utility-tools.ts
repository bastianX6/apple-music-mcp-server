import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { CallToolResult } from '@modelcontextprotocol/sdk/types.js';
import { z } from 'zod';
import { AppleMusicClient } from '../api/client.js';

export function registerUtilityTools(server: McpServer, client: AppleMusicClient): void {
  const genericRequestSchema = z.object({
    endpoint: z.string().min(1).describe('API endpoint path (e.g., /v1/catalog/us/songs/1441164589)'),
    method: z.enum(['GET', 'POST']).default('GET').describe('HTTP method'),
    useUserToken: z.boolean().default(false).describe('Use user token for authentication'),
    body: z.record(z.unknown()).optional().describe('Request body for POST requests'),
  });

  server.registerTool(
    'generic_request',
    {
      title: 'Generic API Request',
      description: 'Make a generic request to any Apple Music API endpoint for maximum flexibility',
      inputSchema: genericRequestSchema,
    },
    async (args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const { endpoint, method, useUserToken, body } = genericRequestSchema.parse(args);

        // Ensure endpoint starts with /
        const path = endpoint.startsWith('/') ? endpoint : `/${endpoint}`;

        let data: unknown;
        if (method === 'POST') {
          if (!body) {
            throw new Error('POST requests require a body parameter');
          }
          data = await client.post(path, body, useUserToken);
        } else {
          data = await client.get(path, useUserToken);
        }

        return {
          content: [{ type: 'text', text: JSON.stringify(data, null, 2) }],
          structuredContent: data,
        };
      } catch (err) {
        return {
          content: [{ type: 'text', text: err instanceof Error ? err.message : String(err) }],
          isError: true,
        };
      }
    },
  );
}

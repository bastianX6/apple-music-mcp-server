import { z } from 'zod';
import { AppleMusicClient } from '../api/client.js';
import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { CallToolResult } from '@modelcontextprotocol/sdk/types.js';

export function registerSearchTools(server: McpServer, client: AppleMusicClient): void {
  const inputSchema = z.object({
    term: z.string().min(1),
    storefront: z.string().length(2).default('us'),
    types: z.array(z.enum(['songs', 'albums', 'artists', 'playlists'])).default(['songs']),
    limit: z.number().min(1).max(25).default(10),
  });

  server.registerTool(
    'search_catalog',
    {
      title: 'Search Apple Music Catalog',
      description: 'Search songs, albums, artists, and playlists in the Apple Music catalog',
      inputSchema,
      outputSchema: z.any(),
    },
    async (args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const { term, storefront, types, limit } = inputSchema.parse(args);
        const params = new URLSearchParams({ term, limit: String(limit) });
        if (types.length) params.set('types', types.join(','));

        const data = await client.get(`/v1/catalog/${storefront}/search?${params.toString()}`, false);
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

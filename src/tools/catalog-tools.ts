import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { CallToolResult } from '@modelcontextprotocol/sdk/types.js';
import { z } from 'zod';
import { AppleMusicClient } from '../api/client.js';

export function registerCatalogTools(server: McpServer, client: AppleMusicClient): void {
  const idSchema = z.object({ ids: z.string(), storefront: z.string().default('us') });
  const chartsSchema = z.object({
    storefront: z.string().default('us'),
    types: z.array(z.string()).default(['songs']),
    limit: z.number().min(1).max(100).default(25),
  });

  server.registerTool(
    'get_catalog_songs',
    {
      title: 'Get Catalog Songs',
      description: 'Retrieve songs from Apple Music catalog by IDs',
      inputSchema: idSchema,
      outputSchema: z.any(),
    },
    async (args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const { ids, storefront } = idSchema.parse(args);
        const data = await client.get(`/v1/catalog/${storefront}/songs?ids=${ids}`, false);
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

  server.registerTool(
    'get_catalog_albums',
    {
      title: 'Get Catalog Albums',
      description: 'Retrieve albums from Apple Music catalog by IDs',
      inputSchema: idSchema,
      outputSchema: z.any(),
    },
    async (args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const { ids, storefront } = idSchema.parse(args);
        const data = await client.get(`/v1/catalog/${storefront}/albums?ids=${ids}`, false);
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

  server.registerTool(
    'get_catalog_artists',
    {
      title: 'Get Catalog Artists',
      description: 'Retrieve artists from Apple Music catalog by IDs',
      inputSchema: idSchema,
      outputSchema: z.any(),
    },
    async (args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const { ids, storefront } = idSchema.parse(args);
        const data = await client.get(`/v1/catalog/${storefront}/artists?ids=${ids}`, false);
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

  server.registerTool(
    'get_catalog_playlists',
    {
      title: 'Get Catalog Playlists',
      description: 'Retrieve playlists from Apple Music catalog by IDs',
      inputSchema: idSchema,
      outputSchema: z.any(),
    },
    async (args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const { ids, storefront } = idSchema.parse(args);
        const data = await client.get(`/v1/catalog/${storefront}/playlists?ids=${ids}`, false);
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

  server.registerTool(
    'get_charts',
    {
      title: 'Get Music Charts',
      description: 'Retrieve music charts (Top Charts, etc.)',
      inputSchema: chartsSchema,
      outputSchema: z.any(),
    },
    async (args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const { storefront, types, limit } = chartsSchema.parse(args);
        const params = new URLSearchParams({ types: types.join(','), limit: String(limit) });
        const data = await client.get(`/v1/catalog/${storefront}/charts?${params.toString()}`, false);
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

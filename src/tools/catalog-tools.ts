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
  const listSchema = z.object({
    storefront: z.string().default('us'),
    limit: z.number().min(1).max(100).default(25),
    offset: z.number().min(0).default(0),
  });

  const handleCatalogPlaylists = async (args: Record<string, unknown>): Promise<CallToolResult> => {
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
  };

  server.registerTool(
    'get_catalog_songs',
    {
      title: 'Get Catalog Songs',
      description: 'Retrieve songs from Apple Music catalog by IDs',
      inputSchema: idSchema,
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
    },
    handleCatalogPlaylists,
  );

  server.registerTool(
    'get_catalog_playlist',
    {
      title: 'Get Catalog Playlist',
      description: 'Alias for retrieving catalog playlists by IDs',
      inputSchema: idSchema,
    },
    handleCatalogPlaylists,
  );

  server.registerTool(
    'get_charts',
    {
      title: 'Get Music Charts',
      description: 'Retrieve music charts (Top Charts, etc.)',
      inputSchema: chartsSchema,
    },
    async (args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const { storefront, types, limit } = chartsSchema.parse(args);
        const params = new URLSearchParams({
          types: types.join(','),
          limit: String(limit),
        });
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

  server.registerTool(
    'get_activities',
    {
      title: 'Get Activities',
      description: 'Retrieve specific editorial activities and curated content collections by their IDs (IDs are Apple-controlled editorial content)',
      inputSchema: idSchema,
    },
    async (args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const { ids, storefront } = idSchema.parse(args);
        const data = await client.get(`/v1/catalog/${storefront}/activities?ids=${ids}`, false);
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
    'get_music_videos',
    {
      title: 'Get Music Videos',
      description: 'Retrieve music videos from Apple Music catalog by IDs',
      inputSchema: idSchema,
    },
    async (args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const { ids, storefront } = idSchema.parse(args);
        const data = await client.get(`/v1/catalog/${storefront}/music-videos?ids=${ids}`, false);
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
    'get_genres',
    {
      title: 'Get Genres',
      description: 'Retrieve music genres available in Apple Music catalog',
      inputSchema: z.object({ 
        ids: z.string().optional(),
        storefront: z.string().default('us'),
        limit: z.number().min(1).max(100).default(25),
      }),
    },
    async (args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const parsed = z.object({ 
          ids: z.string().optional(),
          storefront: z.string().default('us'),
          limit: z.number().min(1).max(100).default(25),
        }).parse(args);
        
        const params = new URLSearchParams({ limit: String(parsed.limit) });
        const endpoint = parsed.ids 
          ? `/v1/catalog/${parsed.storefront}/genres?ids=${parsed.ids}`
          : `/v1/catalog/${parsed.storefront}/genres?${params.toString()}`;
        
        const data = await client.get(endpoint, false);
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
    'get_curators',
    {
      title: 'Get Curators',
      description: 'Retrieve Apple Music curators by IDs',
      inputSchema: idSchema,
    },
    async (args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const { ids, storefront } = idSchema.parse(args);
        const data = await client.get(`/v1/catalog/${storefront}/curators?ids=${ids}`, false);
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
    'get_radio_shows',
    {
      title: 'Get Radio Shows',
      description: 'Retrieve radio shows from Apple Music by IDs',
      inputSchema: idSchema,
    },
    async (args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const { ids, storefront } = idSchema.parse(args);
        const data = await client.get(`/v1/catalog/${storefront}/radio-shows?ids=${ids}`, false);
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
    'get_stations',
    {
      title: 'Get Stations',
      description: 'Retrieve radio stations from Apple Music by IDs',
      inputSchema: idSchema,
    },
    async (args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const { ids, storefront } = idSchema.parse(args);
        const data = await client.get(`/v1/catalog/${storefront}/stations?ids=${ids}`, false);
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
    'get_record_labels',
    {
      title: 'Get Record Labels',
      description: 'Retrieve record labels from Apple Music catalog by IDs',
      inputSchema: idSchema,
    },
    async (args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const { ids, storefront } = idSchema.parse(args);
        const data = await client.get(`/v1/catalog/${storefront}/record-labels?ids=${ids}`, false);
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

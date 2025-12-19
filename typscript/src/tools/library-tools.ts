import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { CallToolResult } from '@modelcontextprotocol/sdk/types.js';
import { z } from 'zod';
import { AppleMusicClient } from '../api/client.js';

export function registerLibraryTools(server: McpServer, client: AppleMusicClient): void {
  const commonSchema = z.object({
    limit: z.number().int().min(1).max(100).default(25),
    offset: z.number().int().min(0).default(0),
  });

  const handleLibraryPlaylists = async (args: Record<string, unknown>): Promise<CallToolResult> => {
    try {
      const { limit, offset } = commonSchema.parse(args);
      const params = new URLSearchParams({ limit: String(limit), offset: String(offset) });
      const data = await client.get(`/v1/me/library/playlists?${params.toString()}`, true);
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
    'get_library_playlists',
    {
      title: 'Get My Playlists',
      description: 'Retrieve your personal library playlists',
      inputSchema: commonSchema,
    },
    handleLibraryPlaylists,
  );

  server.registerTool(
    'get_library_playlist',
    {
      title: 'Get My Playlist',
      description: 'Alias for retrieving personal library playlists',
      inputSchema: commonSchema,
    },
    handleLibraryPlaylists,
  );

  server.registerTool(
    'get_library_songs',
    {
      title: 'Get My Songs',
      description: 'Retrieve your personal library songs',
      inputSchema: commonSchema,
    },
    async (args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const { limit, offset } = commonSchema.parse(args);
        const params = new URLSearchParams({ limit: String(limit), offset: String(offset) });
        const data = await client.get(`/v1/me/library/songs?${params.toString()}`, true);
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
    'get_library_albums',
    {
      title: 'Get My Albums',
      description: 'Retrieve your personal library albums',
      inputSchema: commonSchema,
    },
    async (args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const { limit, offset } = commonSchema.parse(args);
        const params = new URLSearchParams({ limit: String(limit), offset: String(offset) });
        const data = await client.get(`/v1/me/library/albums?${params.toString()}`, true);
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
    'get_library_artists',
    {
      title: 'Get My Artists',
      description: 'Retrieve your saved artists from personal library',
      inputSchema: commonSchema,
    },
    async (args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const { limit, offset } = commonSchema.parse(args);
        const params = new URLSearchParams({ limit: String(limit), offset: String(offset) });
        const data = await client.get(`/v1/me/library/artists?${params.toString()}`, true);
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
    'get_user_storefront',
    {
      title: 'Get My Storefront',
      description: 'Retrieve your Apple Music storefront (region/locale)',
    },
    async (_args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const data = await client.get('/v1/me/storefront', true);
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
    'get_recently_played',
    {
      title: 'Get Recently Played',
      description: 'Retrieve your recent playback history',
      inputSchema: commonSchema,
    },
    async (args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const { limit, offset } = commonSchema.parse(args);
        const params = new URLSearchParams({ limit: String(limit), offset: String(offset) });
        const data = await client.get(`/v1/me/recent/played?${params.toString()}`, true);
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

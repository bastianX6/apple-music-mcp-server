import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { CallToolResult } from '@modelcontextprotocol/sdk/types.js';
import { z } from 'zod';
import { AppleMusicClient } from '../api/client.js';

export function registerManagementTools(server: McpServer, client: AppleMusicClient): void {
  const addSongsSchema = z.object({ ids: z.string().min(1) });
  const addAlbumsSchema = z.object({ ids: z.string().min(1) });
  const createPlaylistSchema = z.object({ name: z.string().min(1), description: z.string().optional() });
  const addItemsSchema = z.object({ playlistId: z.string().min(1), songIds: z.string().min(1) });
  const favoritesSchema = z.object({
    resourceId: z.string().min(1),
    resourceType: z.enum(['songs', 'albums', 'playlists']),
  });

  server.registerTool(
    'add_songs_to_library',
    {
      title: 'Add Songs to Library',
      description: 'Save songs to your personal library',
      inputSchema: addSongsSchema,
      outputSchema: z.any(),
    },
    async (args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const { ids } = addSongsSchema.parse(args);
        const songIds = ids.split(',').map((id) => ({ id: id.trim(), type: 'songs' }));
        const data = await client.post('/v1/me/library/songs', { data: songIds }, true);
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
    'add_albums_to_library',
    {
      title: 'Add Albums to Library',
      description: 'Save albums to your personal library',
      inputSchema: addAlbumsSchema,
      outputSchema: z.any(),
    },
    async (args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const { ids } = addAlbumsSchema.parse(args);
        const albumIds = ids.split(',').map((id) => ({ id: id.trim(), type: 'albums' }));
        const data = await client.post('/v1/me/library/albums', { data: albumIds }, true);
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
    'create_playlist',
    {
      title: 'Create New Playlist',
      description: 'Create a new playlist in your personal library',
      inputSchema: createPlaylistSchema,
      outputSchema: z.any(),
    },
    async (args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const { name, description } = createPlaylistSchema.parse(args);
        const payload = { attributes: { name, description } };
        const data = await client.post('/v1/me/library/playlists', payload, true);
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
    'add_items_to_playlist',
    {
      title: 'Add Items to Playlist',
      description: 'Add songs to an existing playlist',
      inputSchema: addItemsSchema,
      outputSchema: z.any(),
    },
    async (args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const { playlistId, songIds } = addItemsSchema.parse(args);
        const tracks = songIds.split(',').map((id) => ({ id: id.trim(), type: 'songs' }));
        const data = await client.post(
          `/v1/me/library/playlists/${playlistId}/tracks`,
          { data: tracks },
          true,
        );
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
    'add_to_favorites',
    {
      title: 'Add to Favorites',
      description: 'Add a resource (song, album, playlist) to your favorites',
      inputSchema: favoritesSchema,
      outputSchema: z.any(),
    },
    async (args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const { resourceId, resourceType } = favoritesSchema.parse(args);
        const payload = { data: [{ id: resourceId, type: resourceType }] };
        const data = await client.post('/v1/me/favorites', payload, true);
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

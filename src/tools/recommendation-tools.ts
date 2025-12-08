import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { CallToolResult } from '@modelcontextprotocol/sdk/types.js';
import { z } from 'zod';
import { AppleMusicClient } from '../api/client.js';

export function registerRecommendationTools(server: McpServer, client: AppleMusicClient): void {
  const recommendationsSchema = z.object({ limit: z.number().int().min(1).max(100).default(25) });
  const replaySchema = z.object({ year: z.number().int().min(2015) });

  server.registerTool(
    'get_recommendations',
    {
      title: 'Get Personalized Recommendations',
      description: 'Retrieve personalized music recommendations based on your listening history',
      inputSchema: recommendationsSchema,
      outputSchema: z.any(),
    },
    async (args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const { limit } = recommendationsSchema.parse(args);
        const params = new URLSearchParams({ limit: String(limit) });
        const data = await client.get(`/v1/me/recommendations?${params.toString()}`, true);
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
    'get_replay_data',
    {
      title: 'Get Your Replay Data',
      description: 'Retrieve your annual Apple Music Replay data for a given year',
      inputSchema: replaySchema,
      outputSchema: z.any(),
    },
    async (args: Record<string, unknown>): Promise<CallToolResult> => {
      try {
        const { year } = replaySchema.parse(args);
        const data = await client.get(`/v1/me/replay/${year}`, true);
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

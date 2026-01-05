# Tool Migration Docs

This folder contains planning and reference documents for evolving this project from an MCP-only server into a dual-surface tool:
- an MCP server (`apple-music-mcp`)
- a standalone CLI (`apple-music-tool`)

All documents here are written to be used directly by an LLM or engineer implementing the change later.

## Contents
- `docs/tool_migration/mcp_tools_guide.md:1` — Current MCP tool surface: tools, parameters, allowed values, and behaviors.
- `docs/tool_migration/apple_music_tool_cli_proposal.md:1` — Proposed `apple-music-tool` CLI design (kebab-case subcommands, output contracts, error envelope, logging).
- `docs/tool_migration/implementation_checklist.md:1` — Implementation checklist per subcommand/tool.

## Related project docs
- `docs/hybrid_tool_spec.md:1` — Hybrid tool design principles and coverage guidance.
- `docs/hybrid_tool_endpoint_mapping.md:1` — Full endpoint-to-tool mapping.
- `docs/API_LIMITATIONS.md:1` — Known Apple API limitations (405/404 behavior, region variance).
- `docs/configuration.md:1` — Config file rules and default path for `apple-music-mcp`.
- `docs/apple_music_api_auth_guide.md:1` — Token model and setup flow details.


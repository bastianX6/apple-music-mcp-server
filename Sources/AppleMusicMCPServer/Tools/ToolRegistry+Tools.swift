import MCP

extension ToolRegistry {
    var tools: [Tool] {
        [
            Tool(
                name: "generic_get",
                description: "GET any Apple Music API path (developer token for catalog, user token for /v1/me).*",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "path": .object([
                            "type": .string("string"),
                            "description": .string("Relative API path, e.g., v1/catalog/us/search?term=ray")
                        ])
                    ]),
                    "required": .array([.string("path")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_user_storefront",
                description: "Return the user's storefront (region/locale) using Music-User-Token.",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([:])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "search_catalog",
                description: "Search Apple Music catalog by term with optional types. When a user token is present the server resolves the user's storefront and ignores the provided storefront override.",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "term": .object([
                            "type": .string("string"),
                            "description": .string("Search term")
                        ]),
                        "storefront": .object([
                            "type": .string("string"),
                            "description": .string("Storefront code (default: us)")
                        ]),
                        "types": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated resource types (songs,albums,playlists,artists,stations,music-videos)")
                        ]),
                        "limit": .object([
                            "type": .string("integer"),
                            "description": .string("Result limit (1-25, default 10)")
                        ]),
                        "offset": .object([
                            "type": .string("integer"),
                            "description": .string("Offset for pagination (default 0)")
                        ]),
                        "with": .object([
                            "type": .string("string"),
                            "description": .string("Additional resource types to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("term")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_search_hints",
                description: "Get search hints for a term. Uses the user's storefront when available.",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "term": .object([
                            "type": .string("string"),
                            "description": .string("Partial search term")
                        ]),
                        "storefront": .object([
                            "type": .string("string"),
                            "description": .string("Storefront code (default: us)")
                        ]),
                        "limit": .object([
                            "type": .string("integer"),
                            "description": .string("Limit (1-25)")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("term")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_search_suggestions",
                description: "Get search suggestions (kinds defaults to terms). Uses the user's storefront when available.",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "term": .object([
                            "type": .string("string"),
                            "description": .string("Partial search term")
                        ]),
                        "storefront": .object([
                            "type": .string("string"),
                            "description": .string("Storefront code (default: us)")
                        ]),
                        "kinds": .object([
                            "type": .string("string"),
                            "description": .string("Suggestion kinds (default: terms)")
                        ]),
                        "types": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated resource types to include")
                        ]),
                        "limit": .object([
                            "type": .string("integer"),
                            "description": .string("Limit (1-25)")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("term")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_charts",
                description: "Fetch charts (songs/albums/playlists) for a storefront (uses the user's storefront when available).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "storefront": .object([
                            "type": .string("string"),
                            "description": .string("Storefront code (default: us)")
                        ]),
                        "types": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated chart types (songs,albums,playlists)")
                        ]),
                        "chart": .object([
                            "type": .string("string"),
                            "description": .string("Chart name (e.g., most-played)")
                        ]),
                        "genre": .object([
                            "type": .string("string"),
                            "description": .string("Filter by genre ID")
                        ]),
                        "limit": .object([
                            "type": .string("integer"),
                            "description": .string("Limit per chart type (1-50, default 10)")
                        ]),
                        "offset": .object([
                            "type": .string("integer"),
                            "description": .string("Offset for pagination (default 0)")
                        ]),
                        "with": .object([
                            "type": .string("string"),
                            "description": .string("Additional resource types to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_genres",
                description: "Fetch catalog genres for a storefront (uses the user's storefront when available).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "storefront": .object([
                            "type": .string("string"),
                            "description": .string("Storefront code (default: us)")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_stations",
                description: "Fetch catalog stations by IDs (comma-separated). Uses the user's storefront when available.",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "storefront": .object([
                            "type": .string("string"),
                            "description": .string("Storefront code (default: us)")
                        ]),
                        "ids": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated station IDs (e.g., ra.978194965 for Apple Music 1)")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("ids")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_catalog_songs",
                description: "Fetch catalog songs by IDs (comma-separated). Uses the user's storefront when available.",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "storefront": .object([
                            "type": .string("string"),
                            "description": .string("Storefront code (default: us)")
                        ]),
                        "ids": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated catalog song IDs")
                        ]),
                        "limit": .object([
                            "type": .string("integer"),
                            "description": .string("Limit (1-25)")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("ids")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_catalog_albums",
                description: "Fetch catalog albums by IDs (comma-separated). Uses the user's storefront when available.",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "storefront": .object([
                            "type": .string("string"),
                            "description": .string("Storefront code (default: us)")
                        ]),
                        "ids": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated catalog album IDs")
                        ]),
                        "limit": .object([
                            "type": .string("integer"),
                            "description": .string("Limit (1-25)")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("ids")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_catalog_artists",
                description: "Fetch catalog artists by IDs (comma-separated). Uses the user's storefront when available.",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "storefront": .object([
                            "type": .string("string"),
                            "description": .string("Storefront code (default: us)")
                        ]),
                        "ids": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated catalog artist IDs")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("ids")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_catalog_playlists",
                description: "Fetch catalog playlists by IDs (comma-separated). Uses the user's storefront when available.",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "storefront": .object([
                            "type": .string("string"),
                            "description": .string("Storefront code (default: us)")
                        ]),
                        "ids": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated catalog playlist IDs")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("ids")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_music_videos",
                description: "Fetch catalog music videos by IDs (comma-separated). Uses the user's storefront when available.",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "storefront": .object([
                            "type": .string("string"),
                            "description": .string("Storefront code (default: us)")
                        ]),
                        "ids": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated catalog music video IDs")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("ids")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_curators",
                description: "Fetch catalog curators by IDs (comma-separated). Uses the user's storefront when available.",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "storefront": .object([
                            "type": .string("string"),
                            "description": .string("Storefront code (default: us)")
                        ]),
                        "ids": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated curator IDs")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("ids")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_activities",
                description: "Fetch catalog activities by IDs (comma-separated). Uses the user's storefront when available.",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "storefront": .object([
                            "type": .string("string"),
                            "description": .string("Storefront code (default: us)")
                        ]),
                        "ids": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated activity IDs (returns empty/400 without valid IDs)")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("ids")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_catalog_resources",
                description: "Fetch catalog resources by type and IDs. Uses the user's storefront when available. Allowed types: songs, albums, artists, playlists, curators, stations, music-videos, activities, genres, record-labels.",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "storefront": .object([
                            "type": .string("string"),
                            "description": .string("Storefront code (default: us)")
                        ]),
                        "type": .object([
                            "type": .string("string"),
                            "description": .string("Resource type (songs,albums,artists,playlists,curators,stations,music-videos,activities)")
                        ]),
                        "ids": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated IDs")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("type"), .string("ids")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_catalog_resource",
                description: "Fetch a single catalog resource by type and ID. Uses the user's storefront when available. Allowed types: songs, albums, artists, playlists, curators, stations, music-videos, activities, genres, record-labels.",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "storefront": .object([
                            "type": .string("string"),
                            "description": .string("Storefront code (default: us)")
                        ]),
                        "type": .object([
                            "type": .string("string"),
                            "description": .string("Resource type (songs,albums,artists,playlists,curators,stations,music-videos,activities)")
                        ]),
                        "id": .object([
                            "type": .string("string"),
                            "description": .string("Resource ID")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("type"), .string("id")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_catalog_relationship",
                description: "Fetch a catalog relationship by name for a resource. Allowed types: songs, albums, artists, playlists, curators, stations, music-videos, activities, genres, record-labels.",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "storefront": .object([
                            "type": .string("string"),
                            "description": .string("Storefront code (default: us)")
                        ]),
                        "type": .object([
                            "type": .string("string"),
                            "description": .string("Resource type")
                        ]),
                        "id": .object([
                            "type": .string("string"),
                            "description": .string("Resource ID")
                        ]),
                        "relationship": .object([
                            "type": .string("string"),
                            "description": .string("Relationship name")
                        ]),
                        "limit": .object([
                            "type": .string("integer"),
                            "description": .string("Relationship limit")
                        ]),
                        "offset": .object([
                            "type": .string("integer"),
                            "description": .string("Relationship offset")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("type"), .string("id"), .string("relationship")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_catalog_view",
                description: "Fetch a catalog view by name for a resource. Allowed types: songs, albums, artists, playlists, curators, stations, music-videos, activities, genres, record-labels.",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "storefront": .object([
                            "type": .string("string"),
                            "description": .string("Storefront code (default: us)")
                        ]),
                        "type": .object([
                            "type": .string("string"),
                            "description": .string("Resource type")
                        ]),
                        "id": .object([
                            "type": .string("string"),
                            "description": .string("Resource ID")
                        ]),
                        "view": .object([
                            "type": .string("string"),
                            "description": .string("View name")
                        ]),
                        "limit": .object([
                            "type": .string("integer"),
                            "description": .string("View limit")
                        ]),
                        "offset": .object([
                            "type": .string("integer"),
                            "description": .string("View offset")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("type"), .string("id"), .string("view")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_catalog_multi_by_type_ids",
                description: "Fetch multiple catalog resources using resource-typed ID parameters. Allowed keys inside ids: songs, albums, artists, playlists, curators, stations, music-videos, activities, genres, record-labels.",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "storefront": .object([
                            "type": .string("string"),
                            "description": .string("Storefront code (default: us)")
                        ]),
                        "ids": .object([
                            "type": .string("object"),
                            "description": .string("Object keyed by resource type (e.g., {\"songs\": \"123,456\"})")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("ids")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_record_labels",
                description: "Record labels are not available as resources; returns informative error.",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([:])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_radio_shows",
                description: "Radio shows endpoint is not available (404); returns informative error.",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([:])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_library_playlists",
                description: "List user library playlists (requires Music-User-Token).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "limit": .object([
                            "type": .string("integer"),
                            "description": .string("Result limit (1-100, default 25)")
                        ]),
                        "offset": .object([
                            "type": .string("integer"),
                            "description": .string("Offset for pagination (default 0)")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_library_songs",
                description: "List user library songs (requires Music-User-Token).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "limit": .object([
                            "type": .string("integer"),
                            "description": .string("Result limit (1-100, default 25)")
                        ]),
                        "offset": .object([
                            "type": .string("integer"),
                            "description": .string("Offset for pagination (default 0)")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_library_albums",
                description: "List user library albums (requires Music-User-Token).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "limit": .object([
                            "type": .string("integer"),
                            "description": .string("Result limit (1-100, default 25)")
                        ]),
                        "offset": .object([
                            "type": .string("integer"),
                            "description": .string("Offset for pagination (default 0)")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_library_artists",
                description: "List user library artists (requires Music-User-Token).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "limit": .object([
                            "type": .string("integer"),
                            "description": .string("Result limit (1-100, default 25)")
                        ]),
                        "offset": .object([
                            "type": .string("integer"),
                            "description": .string("Offset for pagination (default 0)")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_library_resources",
                description: "Fetch library resources by type and optional IDs (requires Music-User-Token). Allowed types: songs, albums, artists, playlists, playlist-folders, music-videos.",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "type": .object([
                            "type": .string("string"),
                            "description": .string("Resource type (songs,albums,artists,playlists,playlist-folders,music-videos)")
                        ]),
                        "ids": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated IDs (optional)")
                        ]),
                        "filter[identity]": .object([
                            "type": .string("string"),
                            "description": .string("Filter identity (e.g., playlistsroot)")
                        ]),
                        "limit": .object([
                            "type": .string("integer"),
                            "description": .string("Result limit")
                        ]),
                        "offset": .object([
                            "type": .string("integer"),
                            "description": .string("Offset for pagination")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("type")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_library_resource",
                description: "Fetch a single library resource by type and ID (requires Music-User-Token). Allowed types: songs, albums, artists, playlists, playlist-folders, music-videos.",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "type": .object([
                            "type": .string("string"),
                            "description": .string("Resource type")
                        ]),
                        "id": .object([
                            "type": .string("string"),
                            "description": .string("Resource ID")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("type"), .string("id")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_library_relationship",
                description: "Fetch a library relationship by name for a resource (requires Music-User-Token). Allowed types: songs, albums, artists, playlists, playlist-folders, music-videos.",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "type": .object([
                            "type": .string("string"),
                            "description": .string("Resource type")
                        ]),
                        "id": .object([
                            "type": .string("string"),
                            "description": .string("Resource ID")
                        ]),
                        "relationship": .object([
                            "type": .string("string"),
                            "description": .string("Relationship name")
                        ]),
                        "limit": .object([
                            "type": .string("integer"),
                            "description": .string("Relationship limit")
                        ]),
                        "offset": .object([
                            "type": .string("integer"),
                            "description": .string("Relationship offset")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("type"), .string("id"), .string("relationship")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_library_multi_by_type_ids",
                description: "Fetch multiple library resources using resource-typed ID parameters (requires Music-User-Token). Allowed keys inside ids: library-songs, library-albums, library-artists, library-playlists, library-playlist-folders, library-music-videos.",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "ids": .object([
                            "type": .string("object"),
                            "description": .string("Object keyed by library resource type (e.g., {\"library-songs\": \"123,456\"})")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("ids")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "library_search",
                description: "Search for library resources (requires Music-User-Token).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "term": .object([
                            "type": .string("string"),
                            "description": .string("Search term")
                        ]),
                        "types": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated library types (library-albums,library-artists,library-music-videos,library-playlists,library-songs)")
                        ]),
                        "limit": .object([
                            "type": .string("integer"),
                            "description": .string("Result limit (1-25, default 10)")
                        ]),
                        "offset": .object([
                            "type": .string("integer"),
                            "description": .string("Offset for pagination (default 0)")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("term"), .string("types")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_library_recently_added",
                description: "Get recently added library resources (requires Music-User-Token).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_recently_played",
                description: "List user recently played items (requires Music-User-Token).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "limit": .object([
                            "type": .string("integer"),
                            "description": .string("Result limit (1-100, default 10)")
                        ]),
                        "offset": .object([
                            "type": .string("integer"),
                            "description": .string("Offset for pagination (default 0)")
                        ]),
                        "types": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated types (songs,albums,stations,music-videos)")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_recently_played_tracks",
                description: "List user recently played tracks (requires Music-User-Token).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "limit": .object([
                            "type": .string("integer"),
                            "description": .string("Result limit (1-100, default 10)")
                        ]),
                        "offset": .object([
                            "type": .string("integer"),
                            "description": .string("Offset for pagination (default 0)")
                        ]),
                        "types": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated types (songs,music-videos)")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_recently_played_stations",
                description: "List user recently played stations (requires Music-User-Token).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "limit": .object([
                            "type": .string("integer"),
                            "description": .string("Result limit (1-100, default 10)")
                        ]),
                        "offset": .object([
                            "type": .string("integer"),
                            "description": .string("Offset for pagination (default 0)")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_recommendations",
                description: "Fetch personalized recommendations (requires Music-User-Token).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "ids": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated recommendation IDs")
                        ]),
                        "limit": .object([
                            "type": .string("integer"),
                            "description": .string("Limit (1-50, default 10)")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_recommendation",
                description: "Fetch a single recommendation by ID (requires Music-User-Token).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "id": .object([
                            "type": .string("string"),
                            "description": .string("Recommendation ID")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("id")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_recommendation_relationship",
                description: "Fetch a recommendation relationship by name (requires Music-User-Token).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "id": .object([
                            "type": .string("string"),
                            "description": .string("Recommendation ID")
                        ]),
                        "relationship": .object([
                            "type": .string("string"),
                            "description": .string("Relationship name")
                        ]),
                        "limit": .object([
                            "type": .string("integer"),
                            "description": .string("Relationship limit")
                        ]),
                        "offset": .object([
                            "type": .string("integer"),
                            "description": .string("Relationship offset")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("id"), .string("relationship")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_heavy_rotation",
                description: "Fetch heavy rotation history (requires Music-User-Token).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "limit": .object([
                            "type": .string("integer"),
                            "description": .string("Limit (1-100, default 10)")
                        ]),
                        "offset": .object([
                            "type": .string("integer"),
                            "description": .string("Offset for pagination (default 0)")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_replay_data",
                description: "Fetch replay data via /v1/me/music-summaries (requires Music-User-Token).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "filter[year]": .object([
                            "type": .string("string"),
                            "description": .string("Replay year")
                        ]),
                        "views": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated views (top-artists,top-albums,top-songs)")
                        ]),
                        "include": .object([
                            "type": .string("string"),
                            "description": .string("Relationship data to include")
                        ]),
                        "extend": .object([
                            "type": .string("string"),
                            "description": .string("Extended attributes to include")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("filter[year]")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_replay",
                description: "Replay data endpoint is not available (404); returns informative error.",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "year": .object([
                            "type": .string("string"),
                            "description": .string("Replay year (optional, ignored)")
                        ])
                    ])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "create_playlist",
                description: "Create a library playlist (requires Music-User-Token).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "name": .object([
                            "type": .string("string"),
                            "description": .string("Playlist name")
                        ]),
                        "description": .object([
                            "type": .string("string"),
                            "description": .string("Playlist description (optional)")
                        ]),
                        "tracks": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated track IDs to add (optional)")
                        ]),
                        "parent": .object([
                            "type": .string("string"),
                            "description": .string("Parent folder ID (optional)")
                        ])
                    ]),
                    "required": .array([.string("name")])
                ]),
                annotations: .init(readOnlyHint: false, destructiveHint: false, idempotentHint: false)
            ),
            Tool(
                name: "add_playlist_tracks",
                description: "Add tracks to a library playlist (requires Music-User-Token).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "playlistId": .object([
                            "type": .string("string"),
                            "description": .string("Library playlist ID")
                        ]),
                        "trackIds": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated track IDs (catalog or library)")
                        ])
                    ]),
                    "required": .array([.string("playlistId"), .string("trackIds")])
                ]),
                annotations: .init(readOnlyHint: false, destructiveHint: false, idempotentHint: false)
            ),
            Tool(
                name: "create_playlist_folder",
                description: "Create a library playlist folder (requires Music-User-Token).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "name": .object([
                            "type": .string("string"),
                            "description": .string("Folder name")
                        ])
                    ]),
                    "required": .array([.string("name")])
                ]),
                annotations: .init(readOnlyHint: false, destructiveHint: false, idempotentHint: false)
            ),
            Tool(
                name: "add_library_resources",
                description: "Add resources to the user library (requires Music-User-Token).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "ids": .object([
                            "type": .string("object"),
                            "description": .string("Object keyed by resource type (e.g., {\"songs\": \"123,456\"})")
                        ]),
                        "resourceType": .object([
                            "type": .string("string"),
                            "description": .string("Fallback resource type when ids is a string")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("ids")])
                ]),
                annotations: .init(readOnlyHint: false, destructiveHint: false, idempotentHint: false)
            ),
            Tool(
                name: "add_library_songs",
                description: "Add songs to library (may return 405).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "ids": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated song IDs")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("ids")])
                ]),
                annotations: .init(readOnlyHint: false, destructiveHint: false, idempotentHint: false)
            ),
            Tool(
                name: "add_library_albums",
                description: "Add albums to library (may return 405).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "ids": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated album IDs")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("ids")])
                ]),
                annotations: .init(readOnlyHint: false, destructiveHint: false, idempotentHint: false)
            ),
            Tool(
                name: "add_favorites",
                description: "Add favorites (may return 405).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "ids": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated IDs or object keyed by resource type")
                        ]),
                        "resourceType": .object([
                            "type": .string("string"),
                            "description": .string("Resource type when ids is a string (songs,albums,playlists)")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("ids")])
                ]),
                annotations: .init(readOnlyHint: false, destructiveHint: false, idempotentHint: false)
            ),
            Tool(
                name: "set_rating",
                description: "Set a rating for a resource (requires Music-User-Token).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "resourceType": .object([
                            "type": .string("string"),
                            "description": .string("Resource type (songs,albums,playlists,library-songs,library-albums,stations)")
                        ]),
                        "id": .object([
                            "type": .string("string"),
                            "description": .string("Resource ID")
                        ]),
                        "value": .object([
                            "type": .string("integer"),
                            "description": .string("Rating value (e.g., 1 for like, -1 for dislike)")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("resourceType"), .string("id"), .string("value")])
                ]),
                annotations: .init(readOnlyHint: false, destructiveHint: false, idempotentHint: false)
            ),
            Tool(
                name: "delete_rating",
                description: "Delete a rating for a resource (requires Music-User-Token).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "resourceType": .object([
                            "type": .string("string"),
                            "description": .string("Resource type (songs,albums,playlists,library-songs,library-albums,stations)")
                        ]),
                        "id": .object([
                            "type": .string("string"),
                            "description": .string("Resource ID")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("resourceType"), .string("id")])
                ]),
                annotations: .init(readOnlyHint: false, destructiveHint: false, idempotentHint: false)
            ),
            Tool(
                name: "get_best_language_tag",
                description: "Get the best supported language tag for a storefront.",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "storefront": .object([
                            "type": .string("string"),
                            "description": .string("Storefront code (default: us)")
                        ]),
                        "acceptLanguage": .object([
                            "type": .string("string"),
                            "description": .string("Preferred language tag (e.g., es-ES)")
                        ]),
                        "l": .object([
                            "type": .string("string"),
                            "description": .string("Language tag override")
                        ])
                    ]),
                    "required": .array([.string("acceptLanguage")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            )
        ]
    }
}

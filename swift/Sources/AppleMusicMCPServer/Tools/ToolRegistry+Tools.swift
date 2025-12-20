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
                        ])
                    ]),
                    "required": .array([.string("term")])
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
                        ])
                    ])
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
                            "description": .string("Limit (1-25, default 10)")
                        ])
                    ]),
                    "required": .array([.string("ids")])
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
                        ])
                    ])
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
                            "description": .string("Limit (1-25, default 10)")
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
                        ])
                    ]),
                    "required": .array([.string("ids")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_catalog_resources",
                description: "Fetch catalog resources by type and IDs (comma-separated). Uses the user's storefront when available.",
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
                        ])
                    ]),
                    "required": .array([.string("type"), .string("ids")])
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
                        ])
                    ])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_library_resources",
                description: "Fetch library resources by type and IDs (requires Music-User-Token).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "type": .object([
                            "type": .string("string"),
                            "description": .string("Resource type (songs,albums,artists,playlists)")
                        ]),
                        "ids": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated IDs")
                        ])
                    ]),
                    "required": .array([.string("type"), .string("ids")])
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
                        ])
                    ])
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
                        ])
                    ]),
                    "required": .array([.string("ids")])
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
                        ])
                    ])
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
                        "limit": .object([
                            "type": .string("integer"),
                            "description": .string("Limit per chart type (1-50, default 10)")
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
                        ])
                    ]),
                    "required": .array([.string("ids")])
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
                        ])
                    ]),
                    "required": .array([.string("term")])
                ]),
                annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true)
            ),
            Tool(
                name: "get_recommendations",
                description: "Fetch personalized recommendations (requires Music-User-Token).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "limit": .object([
                            "type": .string("integer"),
                            "description": .string("Limit (1-50, default 10)")
                        ])
                    ])
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
                        ])
                    ])
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
                name: "add_library_songs",
                description: "Add songs to library (Apple returns 405).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "ids": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated song IDs")
                        ])
                    ]),
                    "required": .array([.string("ids")])
                ]),
                annotations: .init(readOnlyHint: false, destructiveHint: false, idempotentHint: false)
            ),
            Tool(
                name: "add_library_albums",
                description: "Add albums to library (Apple returns 405).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "ids": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated album IDs")
                        ])
                    ]),
                    "required": .array([.string("ids")])
                ]),
                annotations: .init(readOnlyHint: false, destructiveHint: false, idempotentHint: false)
            ),
            Tool(
                name: "add_favorites",
                description: "Add favorites (Apple returns 405).",
                inputSchema: .object([
                    "type": .string("object"),
                    "properties": .object([
                        "resourceType": .object([
                            "type": .string("string"),
                            "description": .string("Resource type (songs,albums,playlists)")
                        ]),
                        "ids": .object([
                            "type": .string("string"),
                            "description": .string("Comma-separated IDs")
                        ])
                    ]),
                    "required": .array([.string("resourceType"), .string("ids")])
                ]),
                annotations: .init(readOnlyHint: false, destructiveHint: false, idempotentHint: false)
            )
        ]
    }
}

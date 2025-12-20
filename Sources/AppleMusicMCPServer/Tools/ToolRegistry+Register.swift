import MCP

extension ToolRegistry {
    func register(on server: Server) async {
        await server.withMethodHandler(ListTools.self) { _ in
            .init(tools: tools)
        }

        await server.withMethodHandler(CallTool.self) { params in
            switch params.name {
            case "generic_get":
                return try await handleGenericGet(params: params)
            case "get_user_storefront":
                return try await handleGetUserStorefront()
            case "search_catalog":
                return try await handleSearchCatalog(params: params)
            case "get_library_playlists":
                return try await handleGetLibraryPlaylists(params: params)
            case "get_catalog_songs":
                return try await handleGetCatalogSongs(params: params)
            case "get_library_songs":
                return try await handleGetLibrarySongs(params: params)
            case "get_catalog_albums":
                return try await handleGetCatalogAlbums(params: params)
            case "get_catalog_artists":
                return try await handleGetCatalogArtists(params: params)
            case "get_catalog_playlists":
                return try await handleGetCatalogPlaylists(params: params)
            case "get_curators":
                return try await handleGetCurators(params: params)
            case "get_activities":
                return try await handleGetActivities(params: params)
            case "get_catalog_resources":
                return try await handleGetCatalogResources(params: params)
            case "get_record_labels":
                return try await handleGetRecordLabels(params: params)
            case "get_radio_shows":
                return try await handleGetRadioShows(params: params)
            case "get_library_albums":
                return try await handleGetLibraryAlbums(params: params)
            case "get_library_artists":
                return try await handleGetLibraryArtists(params: params)
            case "get_library_resources":
                return try await handleGetLibraryResources(params: params)
            case "get_recently_played":
                return try await handleGetRecentlyPlayed(params: params)
            case "get_music_videos":
                return try await handleGetMusicVideos(params: params)
            case "get_genres":
                return try await handleGetGenres(params: params)
            case "get_charts":
                return try await handleGetCharts(params: params)
            case "get_stations":
                return try await handleGetStations(params: params)
            case "get_search_suggestions":
                return try await handleGetSearchSuggestions(params: params)
            case "get_recommendations":
                return try await handleGetRecommendations(params: params)
            case "get_heavy_rotation":
                return try await handleGetHeavyRotation(params: params)
            case "get_replay":
                return try await handleGetReplay(params: params)
            case "create_playlist":
                return try await handleCreatePlaylist(params: params)
            case "add_playlist_tracks":
                return try await handleAddPlaylistTracks(params: params)
            case "add_library_songs":
                return try await handleAddLibrarySongs(params: params)
            case "add_library_albums":
                return try await handleAddLibraryAlbums(params: params)
            case "add_favorites":
                return try await handleAddFavorites(params: params)
            default:
                return CallTool.Result(content: [.text("Unknown tool: \(params.name)")], isError: true)
            }
        }
    }
}

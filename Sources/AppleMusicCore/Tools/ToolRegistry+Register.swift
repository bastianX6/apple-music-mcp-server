import MCP

extension ToolRegistry {
    public func register(on server: Server) async {
        await server.withMethodHandler(ListTools.self) { _ in
            .init(tools: tools)
        }

        await server.withMethodHandler(CallTool.self) { params in
            return try await callTool(params: params)
        }
    }

    public func callTool(params: CallTool.Parameters) async throws -> CallTool.Result {
        if let storefrontError = await prefetchStorefrontIfNeeded(toolName: params.name) {
            return storefrontError
        }
        if disabledToolNames.contains(params.name) {
            return CallTool.Result(content: [.text("Tool \(params.name) is currently disabled")], isError: true)
        }
        return try await handleTool(params: params)
    }

    private func handleTool(params: CallTool.Parameters) async throws -> CallTool.Result {
        switch params.name {
        case "generic_get":
            return try await handleGenericGet(params: params)
        case "get_user_storefront":
            return try await handleGetUserStorefront()
        case "search_catalog":
            return try await handleSearchCatalog(params: params)
        case "get_search_hints":
            return try await handleGetSearchHints(params: params)
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
        case "get_catalog_resource":
            return try await handleGetCatalogResource(params: params)
        case "get_catalog_relationship":
            return try await handleGetCatalogRelationship(params: params)
        case "get_catalog_view":
            return try await handleGetCatalogView(params: params)
        case "get_catalog_multi_by_type_ids":
            return try await handleGetCatalogMultiByTypeIds(params: params)
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
        case "get_library_resource":
            return try await handleGetLibraryResource(params: params)
        case "get_library_relationship":
            return try await handleGetLibraryRelationship(params: params)
        case "get_library_multi_by_type_ids":
            return try await handleGetLibraryMultiByTypeIds(params: params)
        case "library_search":
            return try await handleLibrarySearch(params: params)
        case "get_library_recently_added":
            return try await handleGetLibraryRecentlyAdded(params: params)
        case "get_recently_played":
            return try await handleGetRecentlyPlayed(params: params)
        case "get_recently_played_tracks":
            return try await handleGetRecentlyPlayedTracks(params: params)
        case "get_recently_played_stations":
            return try await handleGetRecentlyPlayedStations(params: params)
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
        case "get_recommendation":
            return try await handleGetRecommendation(params: params)
        case "get_recommendation_relationship":
            return try await handleGetRecommendationRelationship(params: params)
        case "get_heavy_rotation":
            return try await handleGetHeavyRotation(params: params)
        case "get_replay_data":
            return try await handleGetReplayData(params: params)
        case "get_replay":
            return try await handleGetReplay(params: params)
        case "create_playlist":
            return try await handleCreatePlaylist(params: params)
        case "add_playlist_tracks":
            return try await handleAddPlaylistTracks(params: params)
        case "create_playlist_folder":
            return try await handleCreatePlaylistFolder(params: params)
        case "add_library_resources":
            return try await handleAddLibraryResources(params: params)
        case "add_library_songs":
            return try await handleAddLibrarySongs(params: params)
        case "add_library_albums":
            return try await handleAddLibraryAlbums(params: params)
        case "add_favorites":
            return try await handleAddFavorites(params: params)
        case "set_rating":
            return try await handleSetRating(params: params)
        case "delete_rating":
            return try await handleDeleteRating(params: params)
        case "get_best_language_tag":
            return try await handleGetBestLanguageTag(params: params)
        default:
            return CallTool.Result(content: [.text("Unknown tool: \(params.name)")], isError: true)
        }
    }
}

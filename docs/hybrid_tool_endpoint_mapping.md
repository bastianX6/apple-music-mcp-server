# Endpoint to Tool Mapping (Hybrid)

This mapping covers every endpoint listed in `docs/apple_music_api_endpoints.md`.
Use intent tools when possible; otherwise use the generic tools listed here.

| Method | Path | Title | Tool |
| --- | --- | --- | --- |
| GET | `v1/catalog/{storefront}` | Get Multiple Catalog Resources Using Resource-Typed ID Parameters | `get_catalog_multi_by_type_ids` |
| GET | `v1/catalog/{storefront}/activities` | Get Multiple Catalog Activities | `get_activities` |
| GET | `v1/catalog/{storefront}/activities/{id}` | Get a Catalog Activity | `get_catalog_resource` |
| GET | `v1/catalog/{storefront}/activities/{id}/{relationship}` | Get a Catalog Activity's Relationship Directly by Name | `get_catalog_relationship` |
| GET | `v1/catalog/{storefront}/albums` | Get Multiple Catalog Albums | `get_catalog_albums` |
| GET | `v1/catalog/{storefront}/albums/{id}` | Get a Catalog Album | `get_catalog_resource` |
| GET | `v1/catalog/{storefront}/albums/{id}/view/{view}` | Get a Catalog Album’s Relationship View Directly by Name | `get_catalog_view` |
| GET | `v1/catalog/{storefront}/albums/{id}/{relationship}` | Get a Catalog Album's Relationship Directly by Name | `get_catalog_relationship` |
| GET | `v1/catalog/{storefront}/apple-curators` | Get Multiple Catalog Apple Curators | `get_catalog_resources` |
| GET | `v1/catalog/{storefront}/apple-curators/{id}` | Get a Catalog Apple Curator | `get_catalog_resource` |
| GET | `v1/catalog/{storefront}/apple-curators/{id}/{relationship}` | Get a Catalog Apple Curator's Relationship Directly by Name | `get_catalog_relationship` |
| GET | `v1/catalog/{storefront}/artists` | Get Multiple Catalog Artists | `get_catalog_artists` |
| GET | `v1/catalog/{storefront}/artists/{id}` | Get a Catalog Artist | `get_catalog_resource` |
| GET | `v1/catalog/{storefront}/artists/{id}/view/{view}` | Get a Catalog Artist’s Relationship View Directly by Name | `get_catalog_view` |
| GET | `v1/catalog/{storefront}/artists/{id}/{relationship}` | Get a Catalog Artist's Relationship Directly by Name | `get_catalog_relationship` |
| GET | `v1/catalog/{storefront}/charts` | Get Catalog Charts | `get_charts` |
| GET | `v1/catalog/{storefront}/curators` | Get Multiple Catalog Curators | `get_curators` |
| GET | `v1/catalog/{storefront}/curators/{id}` | Get a Catalog Curator | `get_catalog_resource` |
| GET | `v1/catalog/{storefront}/curators/{id}/{relationship}` | Get a Catalog Curator's Relationship Directly by Name | `get_catalog_relationship` |
| GET | `v1/catalog/{storefront}/genres` | Get Multiple Catalog Genres | `get_genres` |
| GET | `v1/catalog/{storefront}/genres/{id}` | Get a Catalog Genre | `get_catalog_resource` |
| GET | `v1/catalog/{storefront}/music-videos` | Get Multiple Catalog Music Videos by ID | `get_music_videos` |
| GET | `v1/catalog/{storefront}/music-videos/{id}` | Get a Catalog Music Video | `get_catalog_resource` |
| GET | `v1/catalog/{storefront}/music-videos/{id}/view/{view}` | Get a Catalog Music Video’s Relationship View Directly by Name | `get_catalog_view` |
| GET | `v1/catalog/{storefront}/music-videos/{id}/{relationship}` | Get a Catalog Music Video's Relationship Directly by Name | `get_catalog_relationship` |
| GET | `v1/catalog/{storefront}/playlists` | Get Multiple Catalog Playlists | `get_catalog_playlists` |
| GET | `v1/catalog/{storefront}/playlists/{id}` | Get a Catalog Playlist | `get_catalog_resource` |
| GET | `v1/catalog/{storefront}/playlists/{id}/view/{view}` | Get a Catalog Playlist’s Relationship View Directly by Name | `get_catalog_view` |
| GET | `v1/catalog/{storefront}/playlists/{id}/{relationship}` | Get a Catalog Playlist's Relationship Directly by Name | `get_catalog_relationship` |
| GET | `v1/catalog/{storefront}/record-labels` | Get Multiple Record Labels | `get_catalog_resources` |
| GET | `v1/catalog/{storefront}/record-labels/{id}` | Get a Catalog Record Label | `get_catalog_resource` |
| GET | `v1/catalog/{storefront}/record-labels/{id}/view/{view}` | Get a Catalog Record Label’s Relationship View Directly by Name | `get_catalog_view` |
| GET | `v1/catalog/{storefront}/search` | Search for Catalog Resources | `search_catalog` |
| GET | `v1/catalog/{storefront}/search/hints` | Get Catalog Search Hints | `get_search_hints` |
| GET | `v1/catalog/{storefront}/search/suggestions` | Get Catalog Search Suggestions | `get_search_suggestions` |
| GET | `v1/catalog/{storefront}/songs` | Get Multiple Catalog Songs by ID | `get_catalog_songs` |
| GET | `v1/catalog/{storefront}/songs/{id}` | Get a Catalog Song | `get_catalog_resource` |
| GET | `v1/catalog/{storefront}/songs/{id}/{relationship}` | Get a Catalog Song's Relationship Directly by Name | `get_catalog_relationship` |
| GET | `v1/catalog/{storefront}/station-genres` | Get Multiple Stations Genres | `get_catalog_resources` |
| GET | `v1/catalog/{storefront}/station-genres/{id}` | Get a Station Genre | `get_catalog_resource` |
| GET | `v1/catalog/{storefront}/station-genres/{id}/{relationship}` | Get a Station Genre’s Relationship Directly by Name | `get_catalog_relationship` |
| GET | `v1/catalog/{storefront}/stations` | Get Multiple Catalog Stations | `get_stations` |
| GET | `v1/catalog/{storefront}/stations/{id}` | Get a Catalog Station | `get_catalog_resource` |
| GET | `v1/catalog/{storefront}/stations/{id}/{relationship}` | Get a Catalog Station's Relationship Directly by Name | `get_catalog_relationship` |
| GET | `v1/language/{storefront}/tag` | Get the best supported language for a storefront | `get_best_language_tag` |
| POST | `v1/me/favorites` | Add resource to favorites | `add_favorites` |
| GET | `v1/me/history/heavy-rotation` | Get Heavy Rotation Content | `get_heavy_rotation` |
| GET | `v1/me/library` | Get Multiple Library Resources Using Resource-Typed ID Parameters | `get_library_multi_by_type_ids` |
| POST | `v1/me/library` | Add a Resource to a Library | `add_library_resources` |
| GET | `v1/me/library/albums` | Get Multiple Library Albums | `get_library_albums` |
| GET | `v1/me/library/albums/{id}` | Get a Library Album | `get_library_resource` |
| GET | `v1/me/library/albums/{id}/{relationship}` | Get a Library Album's Relationship Directly by Name | `get_library_relationship` |
| GET | `v1/me/library/artists` | Get Multiple Library Artists | `get_library_artists` |
| GET | `v1/me/library/artists/{id}` | Get a Library Artist | `get_library_resource` |
| GET | `v1/me/library/artists/{id}/{relationship}` | Get a Library Artist's Relationship Directly by Name | `get_library_relationship` |
| GET | `v1/me/library/music-videos` | Get Multiple Library Music Videos | `get_library_resources` |
| GET | `v1/me/library/music-videos/{id}` | Get a Library Music Video | `get_library_resource` |
| GET | `v1/me/library/music-videos/{id}/{relationship}` | Get a Library Music Video's Relationship Directly by Name | `get_library_relationship` |
| GET | `v1/me/library/playlist-folders` | Get Root Library Playlists Folder | `get_library_resources` |
| POST | `v1/me/library/playlist-folders` | Create a New Library Playlist Folder | `create_playlist_folder` |
| GET | `v1/me/library/playlist-folders/{id}` | Get a Library Playlist Folder | `get_library_resource` |
| GET | `v1/me/library/playlist-folders/{id}/{relationship}` | Get a Library Playlist Folder’s Relationship Directly by Name | `get_library_relationship` |
| GET | `v1/me/library/playlists` | Get Multiple Library Playlists | `get_library_playlists` |
| POST | `v1/me/library/playlists` | Create a New Library Playlist | `create_playlist` |
| GET | `v1/me/library/playlists/{id}` | Get a Library Playlist | `get_library_resource` |
| POST | `v1/me/library/playlists/{id}/tracks` | Add Tracks to a Library Playlist | `add_playlist_tracks` |
| GET | `v1/me/library/playlists/{id}/{relationship}` | Get a Library Playlist's Relationship Directly by Name | `get_library_relationship` |
| GET | `v1/me/library/recently-added` | Get Recently Added Resources | `get_library_recently_added` |
| GET | `v1/me/library/search` | Search for Library Resources | `library_search` |
| GET | `v1/me/library/songs` | Get Multiple Library Songs | `get_library_songs` |
| GET | `v1/me/library/songs/{id}` | Get a Library Song | `get_library_resource` |
| GET | `v1/me/library/songs/{id}/{relationship}` | Get a Library Song's Relationship Directly by Name | `get_library_relationship` |
| GET | `v1/me/music-summaries` | Get the user's replay data | `get_replay_data` |
| GET | `v1/me/ratings/albums` | Get Multiple Personal Album Ratings | `generic_get` |
| DELETE | `v1/me/ratings/albums/{id}` | Delete a Personal Album Rating | `delete_rating` |
| GET | `v1/me/ratings/albums/{id}` | Get a Personal Album Rating | `generic_get` |
| PUT | `v1/me/ratings/albums/{id}` | Add a Personal Album Rating | `set_rating` |
| GET | `v1/me/ratings/library-albums` | Get Multiple Personal Library Album Ratings | `generic_get` |
| DELETE | `v1/me/ratings/library-albums/{id}` | Delete a Personal Library Album Rating | `delete_rating` |
| GET | `v1/me/ratings/library-albums/{id}` | Get a Personal Library Album Rating | `generic_get` |
| PUT | `v1/me/ratings/library-albums/{id}` | Add a Personal Library Album Rating | `set_rating` |
| GET | `v1/me/ratings/library-music-videos` | Get Multiple Personal Library Music Video Ratings | `generic_get` |
| DELETE | `v1/me/ratings/library-music-videos/{id}` | Delete a Personal Library Music Video Rating | `delete_rating` |
| GET | `v1/me/ratings/library-music-videos/{id}` | Get a Personal Library Music Video Rating | `generic_get` |
| PUT | `v1/me/ratings/library-music-videos/{id}` | Add a Personal Library Music Video Rating | `set_rating` |
| GET | `v1/me/ratings/library-playlists` | Get Multiple Personal Library Playlist Ratings | `generic_get` |
| DELETE | `v1/me/ratings/library-playlists/{id}` | Delete a Personal Library Playlist Rating | `delete_rating` |
| GET | `v1/me/ratings/library-playlists/{id}` | Get a Personal Library Playlist Rating | `generic_get` |
| PUT | `v1/me/ratings/library-playlists/{id}` | Add a Personal Library Playlist Rating | `set_rating` |
| GET | `v1/me/ratings/library-songs` | Get Multiple Personal Library Songs Ratings | `generic_get` |
| DELETE | `v1/me/ratings/library-songs/{id}` | Delete a Personal Library Song Rating | `delete_rating` |
| GET | `v1/me/ratings/library-songs/{id}` | Get a Personal Library Song Rating | `generic_get` |
| PUT | `v1/me/ratings/library-songs/{id}` | Add a Personal Library Song Rating | `set_rating` |
| GET | `v1/me/ratings/music-videos` | Get Multiple Personal Music Video Ratings | `generic_get` |
| DELETE | `v1/me/ratings/music-videos/{id}` | Delete a Personal Music Video Rating | `delete_rating` |
| GET | `v1/me/ratings/music-videos/{id}` | Get a Personal Music Video Rating | `generic_get` |
| PUT | `v1/me/ratings/music-videos/{id}` | Add a Personal Music Video Rating | `set_rating` |
| GET | `v1/me/ratings/playlists` | Get Multiple Personal Playlist Ratings | `generic_get` |
| DELETE | `v1/me/ratings/playlists/{id}` | Delete a Personal Playlist Rating | `delete_rating` |
| GET | `v1/me/ratings/playlists/{id}` | Get a Personal Playlist Rating | `generic_get` |
| PUT | `v1/me/ratings/playlists/{id}` | Add a Personal Playlist Rating | `set_rating` |
| GET | `v1/me/ratings/songs` | Get Multiple Personal Song Ratings | `generic_get` |
| DELETE | `v1/me/ratings/songs/{id}` | Delete a Personal Song Rating | `delete_rating` |
| GET | `v1/me/ratings/songs/{id}` | Get a Personal Song Rating | `generic_get` |
| PUT | `v1/me/ratings/songs/{id}` | Add a Personal Song Rating | `set_rating` |
| GET | `v1/me/ratings/stations` | Get Multiple Personal Station Ratings | `generic_get` |
| DELETE | `v1/me/ratings/stations/{id}` | Delete a Personal Station Rating | `delete_rating` |
| GET | `v1/me/ratings/stations/{id}` | Get a Personal Station Rating | `generic_get` |
| PUT | `v1/me/ratings/stations/{id}` | Add a Personal Station Rating | `set_rating` |
| GET | `v1/me/recent/played` | Get Recently Played Resources | `get_recently_played` |
| GET | `v1/me/recent/played/tracks` | Get Recently Played Tracks | `get_recently_played_tracks` |
| GET | `v1/me/recent/radio-stations` | Get Recently Played Stations | `get_recently_played_stations` |
| GET | `v1/me/recommendations` | Get Multiple Recommendations | `get_recommendations` |
| GET | `v1/me/recommendations/{id}` | Get a Recommendation | `get_recommendation` |
| GET | `v1/me/recommendations/{id}/{relationship}` | Get a Recommendation Relationship Directly by Name | `get_recommendation_relationship` |
| GET | `v1/me/storefront` | Get a User's Storefront | `get_user_storefront` |
| GET | `v1/storefronts` | Get Multiple Storefronts | `generic_get` |
| GET | `v1/storefronts/{id}` | Get a Storefront | `generic_get` |
| GET | `v1/test` | Placeholder Endpoint to Test Connectivity | `generic_get` |

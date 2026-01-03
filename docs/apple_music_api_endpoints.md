# Apple Music API Endpoints (Full)

This list is generated from Apple Developer documentation (Apple Music API).
It complements the MCP tool mapping in `README.md` and the observed limitations in `docs/API_LIMITATIONS.md`.

Auth requirements are inferred from the path:
- `v1/catalog/...` and other non-`/v1/me` endpoints require a Developer Token.
- `v1/me/...` endpoints require a Developer Token plus a Music-User-Token.

Generated: auto

| Method | Path | Title | Auth | Path Params | Query Params | Body |
| --- | --- | --- | --- | --- | --- | --- |
| GET | `v1/catalog/{storefront}` | Get Multiple Catalog Resources Using Resource-Typed ID Parameters | Developer Token | storefront (required) | include, l, extend, ids[stations], ids[station-genres], ids[songs], ids[record-labels], ids[ratings], ids[playlists], ids[music-videos], ids[genres], ids[curators], ids[artists], ids[apple-curators], ids[albums], ids[activities] | - |
| GET | `v1/catalog/{storefront}/activities` | Get Multiple Catalog Activities | Developer Token | storefront (required) | ids (required), include, l, extend | - |
| GET | `v1/catalog/{storefront}/activities/{id}` | Get a Catalog Activity | Developer Token | id (required), storefront (required) | l, include, extend | - |
| GET | `v1/catalog/{storefront}/activities/{id}/{relationship}` | Get a Catalog Activity's Relationship Directly by Name | Developer Token | id (required), relationship (required; values: playlists), storefront (required) | limit, l, include, extend | - |
| GET | `v1/catalog/{storefront}/albums` | Get Multiple Catalog Albums | Developer Token | storefront (required) | ids (required), include, l, extend | - |
| GET | `v1/catalog/{storefront}/albums/{id}` | Get a Catalog Album | Developer Token | id (required), storefront (required) | l, include, views (values: appears-on,other-versions,related-albums,related-videos), extend | - |
| GET | `v1/catalog/{storefront}/albums/{id}/view/{view}` | Get a Catalog Album’s Relationship View Directly by Name | Developer Token | id (required), storefront (required), view (required; values: appears-on,other-versions,related-albums,related-videos) | extend, include, l, limit, with (values: attributes) | - |
| GET | `v1/catalog/{storefront}/albums/{id}/{relationship}` | Get a Catalog Album's Relationship Directly by Name | Developer Token | id (required), relationship (required; values: artists,genres,library,record-labels,tracks), storefront (required) | l, include, limit, extend | - |
| GET | `v1/catalog/{storefront}/apple-curators` | Get Multiple Catalog Apple Curators | Developer Token | storefront (required) | ids (required), include, l, extend | - |
| GET | `v1/catalog/{storefront}/apple-curators/{id}` | Get a Catalog Apple Curator | Developer Token | id (required), storefront (required) | l, include, extend | - |
| GET | `v1/catalog/{storefront}/apple-curators/{id}/{relationship}` | Get a Catalog Apple Curator's Relationship Directly by Name | Developer Token | id (required), relationship (required; values: playlists), storefront (required) | l, include, limit, extend | - |
| GET | `v1/catalog/{storefront}/artists` | Get Multiple Catalog Artists | Developer Token | storefront (required) | ids (required), l, include, extend | - |
| GET | `v1/catalog/{storefront}/artists/{id}` | Get a Catalog Artist | Developer Token | id (required), storefront (required) | l, include, views (values: appears-on-albums,compilation-albums,featured-albums,featured-music-videos,featured-playlists,full-albums,latest-release,live-albums,similar-artists,singles,top-music-videos,top-songs), extend | - |
| GET | `v1/catalog/{storefront}/artists/{id}/view/{view}` | Get a Catalog Artist’s Relationship View Directly by Name | Developer Token | id (required), storefront (required), view (required; values: appears-on-albums,compilation-albums,featured-albums,featured-music-videos,featured-playlists,full-albums,latest-release,live-albums,similar-artists,singles,top-music-videos,top-songs) | extend, include, l, limit, with (values: attributes) | - |
| GET | `v1/catalog/{storefront}/artists/{id}/{relationship}` | Get a Catalog Artist's Relationship Directly by Name | Developer Token | id (required), relationship (required; values: albums,genres,music-videos,playlists,station), storefront (required) | l, include, limit, extend | - |
| GET | `v1/catalog/{storefront}/charts` | Get Catalog Charts | Developer Token | storefront (required) | types (required; values: albums,music-videos,playlists,songs), l, chart (values: most-played), genre, limit, offset, with (values: cityCharts,dailyGlobalTopCharts) | - |
| GET | `v1/catalog/{storefront}/curators` | Get Multiple Catalog Curators | Developer Token | storefront (required) | ids (required), include, l, extend | - |
| GET | `v1/catalog/{storefront}/curators/{id}` | Get a Catalog Curator | Developer Token | id (required), storefront (required) | l, include, extend | - |
| GET | `v1/catalog/{storefront}/curators/{id}/{relationship}` | Get a Catalog Curator's Relationship Directly by Name | Developer Token | id (required), relationship (required; values: playlists), storefront (required) | l, include, limit, extend | - |
| GET | `v1/catalog/{storefront}/genres` | Get Multiple Catalog Genres | Developer Token | storefront (required) | ids (required), l, include, extend | - |
| GET | `v1/catalog/{storefront}/genres/{id}` | Get a Catalog Genre | Developer Token | id (required), storefront (required) | l, include, extend | - |
| GET | `v1/catalog/{storefront}/music-videos` | Get Multiple Catalog Music Videos by ID | Developer Token | storefront (required) | ids (required), l, include, extend | - |
| GET | `v1/catalog/{storefront}/music-videos/{id}` | Get a Catalog Music Video | Developer Token | id (required), storefront (required) | l, include, views (values: more-by-artist,more-in-genre), extend | - |
| GET | `v1/catalog/{storefront}/music-videos/{id}/view/{view}` | Get a Catalog Music Video’s Relationship View Directly by Name | Developer Token | id (required), storefront (required), view (required; values: more-by-artist,more-in-genre) | extend, include, l, limit, with (values: attributes) | - |
| GET | `v1/catalog/{storefront}/music-videos/{id}/{relationship}` | Get a Catalog Music Video's Relationship Directly by Name | Developer Token | id (required), relationship (required; values: albums,artists,genres,library,songs), storefront (required) | l, include, limit, extend | - |
| GET | `v1/catalog/{storefront}/playlists` | Get Multiple Catalog Playlists | Developer Token | storefront (required) | ids (required), l, include, extend | - |
| GET | `v1/catalog/{storefront}/playlists/{id}` | Get a Catalog Playlist | Developer Token | id (required), storefront (required) | l, include, views (values: featured-artists,more-by-curator), extend | - |
| GET | `v1/catalog/{storefront}/playlists/{id}/view/{view}` | Get a Catalog Playlist’s Relationship View Directly by Name | Developer Token | id (required), storefront (required), view (required; values: featured-artists,more-by-curator) | extend, include, l, limit, with (values: attributes) | - |
| GET | `v1/catalog/{storefront}/playlists/{id}/{relationship}` | Get a Catalog Playlist's Relationship Directly by Name | Developer Token | id (required), relationship (required; values: curator,library,tracks), storefront (required) | l, include, limit, extend | - |
| GET | `v1/catalog/{storefront}/record-labels` | Get Multiple Record Labels | Developer Token | storefront (required) | extend, ids (required), include, l | - |
| GET | `v1/catalog/{storefront}/record-labels/{id}` | Get a Catalog Record Label | Developer Token | id (required), storefront (required) | extend, include, l, views (values: latest-releases,top-releases) | - |
| GET | `v1/catalog/{storefront}/record-labels/{id}/view/{view}` | Get a Catalog Record Label’s Relationship View Directly by Name | Developer Token | id (required), storefront (required), view (required; values: latest-releases,top-releases) | extend, include, l, limit, with (values: attributes) | - |
| GET | `v1/catalog/{storefront}/search` | Search for Catalog Resources | Developer Token | storefront (required) | term (required), l, limit, offset, types (required; values: activities,albums,apple-curators,artists,curators,music-videos,playlists,record-labels,songs,stations), with (values: topResults) | - |
| GET | `v1/catalog/{storefront}/search/hints` | Get Catalog Search Hints | Developer Token | storefront (required) | term (required), l, limit | - |
| GET | `v1/catalog/{storefront}/search/suggestions` | Get Catalog Search Suggestions | Developer Token | storefront (required) | kinds (required; values: terms,topResults), l, limit, term (required), types (values: activities,albums,apple-curators,artists,curators,music-videos,playlists,record-labels,songs,stations) | - |
| GET | `v1/catalog/{storefront}/songs` | Get Multiple Catalog Songs by ID | Developer Token | storefront (required) | ids (required), l, include, extend | - |
| GET | `v1/catalog/{storefront}/songs/{id}` | Get a Catalog Song | Developer Token | id (required), storefront (required) | l, include, extend | - |
| GET | `v1/catalog/{storefront}/songs/{id}/{relationship}` | Get a Catalog Song's Relationship Directly by Name | Developer Token | id (required), relationship (required; values: albums,artists,composers,genres,library,music-videos,station), storefront (required) | l, limit, include, extend | - |
| GET | `v1/catalog/{storefront}/station-genres` | Get Multiple Stations Genres | Developer Token | storefront (required) | ids (required), include, l, extend | - |
| GET | `v1/catalog/{storefront}/station-genres/{id}` | Get a Station Genre | Developer Token | id (required), storefront (required) | include, l, extend | - |
| GET | `v1/catalog/{storefront}/station-genres/{id}/{relationship}` | Get a Station Genre’s Relationship Directly by Name | Developer Token | id (required), relationship (required; values: stations), storefront (required) | include, l, limit, extend | - |
| GET | `v1/catalog/{storefront}/stations` | Get Multiple Catalog Stations | Developer Token | storefront (required) | ids (required), l, include, extend | - |
| GET | `v1/catalog/{storefront}/stations/{id}` | Get a Catalog Station | Developer Token | id (required), storefront (required) | include, l, extend | - |
| GET | `v1/catalog/{storefront}/stations/{id}/{relationship}` | Get a Catalog Station's Relationship Directly by Name | Developer Token | id (required), relationship (required; values: radio-show), storefront (required) | l, include, extend, limit | - |
| GET | `v1/language/{storefront}/tag` | Get the best supported language for a storefront | Developer Token | storefront (required) | acceptLanguage (required), l | - |
| POST | `v1/me/favorites` | Add resource to favorites | Developer + Music-User-Token | - | ids (required), l | - |
| GET | `v1/me/history/heavy-rotation` | Get Heavy Rotation Content | Developer + Music-User-Token | - | l, limit, offset, include, extend | - |
| GET | `v1/me/library` | Get Multiple Library Resources Using Resource-Typed ID Parameters | Developer + Music-User-Token | - | include, l, extend, ids[library-songs], ids[library-playlists], ids[library-playlist-folders], ids[library-music-videos], ids[library-artists], ids[library-albums] | - |
| POST | `v1/me/library` | Add a Resource to a Library | Developer + Music-User-Token | - | ids (required), l | - |
| GET | `v1/me/library/albums` | Get Multiple Library Albums | Developer + Music-User-Token | - | ids (required), l, include, extend | - |
| GET | `v1/me/library/albums/{id}` | Get a Library Album | Developer + Music-User-Token | id (required) | l, include, extend | - |
| GET | `v1/me/library/albums/{id}/{relationship}` | Get a Library Album's Relationship Directly by Name | Developer + Music-User-Token | id (required), relationship (required; values: artists,catalog,tracks) | l, include, limit, extend | - |
| GET | `v1/me/library/artists` | Get Multiple Library Artists | Developer + Music-User-Token | - | ids (required), l, include, extend | - |
| GET | `v1/me/library/artists/{id}` | Get a Library Artist | Developer + Music-User-Token | id (required) | l, include, extend | - |
| GET | `v1/me/library/artists/{id}/{relationship}` | Get a Library Artist's Relationship Directly by Name | Developer + Music-User-Token | id (required), relationship (required; values: albums,catalog) | l, include, limit, extend | - |
| GET | `v1/me/library/music-videos` | Get Multiple Library Music Videos | Developer + Music-User-Token | - | ids (required), l, include, extend | - |
| GET | `v1/me/library/music-videos/{id}` | Get a Library Music Video | Developer + Music-User-Token | id (required) | l, include, extend | - |
| GET | `v1/me/library/music-videos/{id}/{relationship}` | Get a Library Music Video's Relationship Directly by Name | Developer + Music-User-Token | id (required), relationship (required; values: albums,artists,catalog) | l, include, limit, extend | - |
| GET | `v1/me/library/playlist-folders` | Get Root Library Playlists Folder | Developer + Music-User-Token | - | filter[identity] (required; values: playlistsroot), include, l, extend | - |
| POST | `v1/me/library/playlist-folders` | Create a New Library Playlist Folder | Developer + Music-User-Token | - | l | LibraryPlaylistFolderCreationRequest |
| GET | `v1/me/library/playlist-folders/{id}` | Get a Library Playlist Folder | Developer + Music-User-Token | id (required) | include, l, extend | - |
| GET | `v1/me/library/playlist-folders/{id}/{relationship}` | Get a Library Playlist Folder’s Relationship Directly by Name | Developer + Music-User-Token | id (required), relationship (required; values: children,parent) | include, l, limit, extend | - |
| GET | `v1/me/library/playlists` | Get Multiple Library Playlists | Developer + Music-User-Token | - | ids (required), l, include, extend | - |
| POST | `v1/me/library/playlists` | Create a New Library Playlist | Developer + Music-User-Token | - | l | LibraryPlaylistCreationRequest |
| GET | `v1/me/library/playlists/{id}` | Get a Library Playlist | Developer + Music-User-Token | id (required) | l, include, extend | - |
| POST | `v1/me/library/playlists/{id}/tracks` | Add Tracks to a Library Playlist | Developer + Music-User-Token | id (required) | l | LibraryPlaylistTracksRequest |
| GET | `v1/me/library/playlists/{id}/{relationship}` | Get a Library Playlist's Relationship Directly by Name | Developer + Music-User-Token | id (required), relationship (required; values: catalog,tracks) | l, include, limit, extend | - |
| GET | `v1/me/library/recently-added` | Get Recently Added Resources | Developer + Music-User-Token | - | l | - |
| GET | `v1/me/library/search` | Search for Library Resources | Developer + Music-User-Token | - | term (required), types (required; values: library-albums,library-artists,library-music-videos,library-playlists,library-songs), limit, offset, l | - |
| GET | `v1/me/library/songs` | Get Multiple Library Songs | Developer + Music-User-Token | - | ids (required), l, include, extend | - |
| GET | `v1/me/library/songs/{id}` | Get a Library Song | Developer + Music-User-Token | id (required) | l, include, extend | - |
| GET | `v1/me/library/songs/{id}/{relationship}` | Get a Library Song's Relationship Directly by Name | Developer + Music-User-Token | id (required), relationship (required; values: albums,artists,catalog) | l, include, limit, extend | - |
| GET | `v1/me/music-summaries` | Get the user's replay data | Developer + Music-User-Token | - | extend, filter[year] (required), include, l, views (values: top-artists,top-albums,top-songs) | - |
| GET | `v1/me/ratings/albums` | Get Multiple Personal Album Ratings | Developer + Music-User-Token | - | ids (required), include, l, extend | - |
| DELETE | `v1/me/ratings/albums/{id}` | Delete a Personal Album Rating | Developer + Music-User-Token | id (required) | l | - |
| GET | `v1/me/ratings/albums/{id}` | Get a Personal Album Rating | Developer + Music-User-Token | id (required) | include, l, extend | - |
| PUT | `v1/me/ratings/albums/{id}` | Add a Personal Album Rating | Developer + Music-User-Token | id (required) | l | RatingRequest |
| GET | `v1/me/ratings/library-albums` | Get Multiple Personal Library Album Ratings | Developer + Music-User-Token | - | ids (required), include, l, extend | - |
| DELETE | `v1/me/ratings/library-albums/{id}` | Delete a Personal Library Album Rating | Developer + Music-User-Token | id (required) | l | - |
| GET | `v1/me/ratings/library-albums/{id}` | Get a Personal Library Album Rating | Developer + Music-User-Token | id (required) | include, l, extend | - |
| PUT | `v1/me/ratings/library-albums/{id}` | Add a Personal Library Album Rating | Developer + Music-User-Token | id (required) | l | RatingRequest |
| GET | `v1/me/ratings/library-music-videos` | Get Multiple Personal Library Music Video Ratings | Developer + Music-User-Token | - | ids (required), include, l, extend | - |
| DELETE | `v1/me/ratings/library-music-videos/{id}` | Delete a Personal Library Music Video Rating | Developer + Music-User-Token | id (required) | l | - |
| GET | `v1/me/ratings/library-music-videos/{id}` | Get a Personal Library Music Video Rating | Developer + Music-User-Token | id (required) | include, l, extend | - |
| PUT | `v1/me/ratings/library-music-videos/{id}` | Add a Personal Library Music Video Rating | Developer + Music-User-Token | id (required) | l | RatingRequest |
| GET | `v1/me/ratings/library-playlists` | Get Multiple Personal Library Playlist Ratings | Developer + Music-User-Token | - | ids (required), include, l, extend | - |
| DELETE | `v1/me/ratings/library-playlists/{id}` | Delete a Personal Library Playlist Rating | Developer + Music-User-Token | id (required) | l | - |
| GET | `v1/me/ratings/library-playlists/{id}` | Get a Personal Library Playlist Rating | Developer + Music-User-Token | id (required) | include, l, extend | - |
| PUT | `v1/me/ratings/library-playlists/{id}` | Add a Personal Library Playlist Rating | Developer + Music-User-Token | id (required) | l | RatingRequest |
| GET | `v1/me/ratings/library-songs` | Get Multiple Personal Library Songs Ratings | Developer + Music-User-Token | - | ids (required), include, l, extend | - |
| DELETE | `v1/me/ratings/library-songs/{id}` | Delete a Personal Library Song Rating | Developer + Music-User-Token | id (required) | l | - |
| GET | `v1/me/ratings/library-songs/{id}` | Get a Personal Library Song Rating | Developer + Music-User-Token | id (required) | include, l, extend | - |
| PUT | `v1/me/ratings/library-songs/{id}` | Add a Personal Library Song Rating | Developer + Music-User-Token | id (required) | l | RatingRequest |
| GET | `v1/me/ratings/music-videos` | Get Multiple Personal Music Video Ratings | Developer + Music-User-Token | - | ids (required), include, l, extend | - |
| DELETE | `v1/me/ratings/music-videos/{id}` | Delete a Personal Music Video Rating | Developer + Music-User-Token | id (required) | l | - |
| GET | `v1/me/ratings/music-videos/{id}` | Get a Personal Music Video Rating | Developer + Music-User-Token | id (required) | include, l, extend | - |
| PUT | `v1/me/ratings/music-videos/{id}` | Add a Personal Music Video Rating | Developer + Music-User-Token | id (required) | l | RatingRequest |
| GET | `v1/me/ratings/playlists` | Get Multiple Personal Playlist Ratings | Developer + Music-User-Token | - | ids (required), include, l, extend | - |
| DELETE | `v1/me/ratings/playlists/{id}` | Delete a Personal Playlist Rating | Developer + Music-User-Token | id (required) | l | - |
| GET | `v1/me/ratings/playlists/{id}` | Get a Personal Playlist Rating | Developer + Music-User-Token | id (required) | include, l, extend | - |
| PUT | `v1/me/ratings/playlists/{id}` | Add a Personal Playlist Rating | Developer + Music-User-Token | id (required) | l | RatingRequest |
| GET | `v1/me/ratings/songs` | Get Multiple Personal Song Ratings | Developer + Music-User-Token | - | ids (required), include, l, extend | - |
| DELETE | `v1/me/ratings/songs/{id}` | Delete a Personal Song Rating | Developer + Music-User-Token | id (required) | l | - |
| GET | `v1/me/ratings/songs/{id}` | Get a Personal Song Rating | Developer + Music-User-Token | id (required) | include, l, extend | - |
| PUT | `v1/me/ratings/songs/{id}` | Add a Personal Song Rating | Developer + Music-User-Token | id (required) | l | RatingRequest |
| GET | `v1/me/ratings/stations` | Get Multiple Personal Station Ratings | Developer + Music-User-Token | - | ids (required), include, l, extend | - |
| DELETE | `v1/me/ratings/stations/{id}` | Delete a Personal Station Rating | Developer + Music-User-Token | id (required) | l | - |
| GET | `v1/me/ratings/stations/{id}` | Get a Personal Station Rating | Developer + Music-User-Token | id (required) | include, l, extend | - |
| PUT | `v1/me/ratings/stations/{id}` | Add a Personal Station Rating | Developer + Music-User-Token | id (required) | l | RatingRequest |
| GET | `v1/me/recent/played` | Get Recently Played Resources | Developer + Music-User-Token | - | l, limit, offset, include, extend, types (required; values: artists,curators,albums,library-albums,playlists,library-playlists,stations) | - |
| GET | `v1/me/recent/played/tracks` | Get Recently Played Tracks | Developer + Music-User-Token | - | include, l, limit, offset, extend, types (required; values: library-music-videos,library-songs,music-videos,songs) | - |
| GET | `v1/me/recent/radio-stations` | Get Recently Played Stations | Developer + Music-User-Token | - | l, limit, offset, include, extend | - |
| GET | `v1/me/recommendations` | Get Multiple Recommendations | Developer + Music-User-Token | - | ids (required), l, include, extend | - |
| GET | `v1/me/recommendations/{id}` | Get a Recommendation | Developer + Music-User-Token | id (required) | l, include, extend | - |
| GET | `v1/me/recommendations/{id}/{relationship}` | Get a Recommendation Relationship Directly by Name | Developer + Music-User-Token | id (required), relationship (required; values: contents) | include, l, limit, extend | - |
| GET | `v1/me/storefront` | Get a User's Storefront | Developer + Music-User-Token | - | l, limit, include, offset, extend | - |
| GET | `v1/storefronts` | Get Multiple Storefronts | Developer Token | - | ids (required), l, include, extend | - |
| GET | `v1/storefronts/{id}` | Get a Storefront | Developer Token | id (required) | l, include, extend | - |
| GET | `v1/test` | Placeholder Endpoint to Test Connectivity | Developer Token | - | l | - |

import ArgumentParser
import Foundation
import AppleMusicCore

@main
struct AppleMusicToolMain: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Apple Music CLI",
        subcommands: [
            SetupCommand.self,
            GetUserStorefrontCommand.self,
            SearchCatalogCommand.self,
            GetSearchHintsCommand.self,
            GetSearchSuggestionsCommand.self,
            GetChartsCommand.self,
            GetGenresCommand.self,
            GetStationsCommand.self,
            GetActivitiesCommand.self,
            GetCatalogSongsCommand.self,
            GetCatalogAlbumsCommand.self,
            GetCatalogArtistsCommand.self,
            GetCatalogPlaylistsCommand.self,
            GetMusicVideosCommand.self,
            GetCuratorsCommand.self,
            GetCatalogResourcesCommand.self,
            GetCatalogResourceCommand.self,
            GetCatalogRelationshipCommand.self,
            GetCatalogViewCommand.self,
            GetCatalogMultiByTypeIdsCommand.self,
            GetBestLanguageTagCommand.self,
            GetRecordLabelsCommand.self,
            GetLibraryPlaylistsCommand.self,
            GetLibrarySongsCommand.self,
            GetLibraryAlbumsCommand.self,
            GetLibraryArtistsCommand.self,
            GetLibraryResourcesCommand.self,
            GetLibraryResourceCommand.self,
            GetLibraryRelationshipCommand.self,
            GetLibraryMultiByTypeIdsCommand.self,
            LibrarySearchCommand.self,
            GetLibraryRecentlyAddedCommand.self,
            GetRecentlyPlayedCommand.self,
            GetRecentlyPlayedTracksCommand.self,
            GetRecentlyPlayedStationsCommand.self,
            GetRecommendationsCommand.self,
            GetRecommendationCommand.self,
            GetRecommendationRelationshipCommand.self,
            GetHeavyRotationCommand.self,
            GetReplayDataCommand.self,
            CreatePlaylistCommand.self,
            AddPlaylistTracksCommand.self,
            CreatePlaylistFolderCommand.self,
            AddLibraryResourcesCommand.self,
            AddLibrarySongsCommand.self,
            AddLibraryAlbumsCommand.self,
            AddFavoritesCommand.self,
            SetRatingCommand.self,
            DeleteRatingCommand.self
        ],
        helpNames: [.long, .short]
    )

    init() {}
}

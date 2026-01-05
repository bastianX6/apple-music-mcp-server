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
            GetCatalogSongsCommand.self,
            GetCatalogAlbumsCommand.self,
            GetCatalogArtistsCommand.self,
            GetCatalogPlaylistsCommand.self,
            GetMusicVideosCommand.self,
            GetCuratorsCommand.self,
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
            GetRecordLabelsCommand.self,
            GetLibraryPlaylistsCommand.self
        ],
        helpNames: [.long, .short]
    )

    init() {}
}

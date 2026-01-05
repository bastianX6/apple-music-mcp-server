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
            GetRecordLabelsCommand.self,
            GetLibraryPlaylistsCommand.self
        ],
        helpNames: [.long, .short]
    )

    init() {}
}

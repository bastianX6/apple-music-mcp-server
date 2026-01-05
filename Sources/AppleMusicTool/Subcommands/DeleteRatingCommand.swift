import ArgumentParser
import MCP

struct DeleteRatingCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "delete-rating",
        abstract: "Delete a rating for a resource."
    )

    @OptionGroup var global: GlobalOptions

    @Option(name: .customLong("resource-type"), help: "Resource type (songs, albums, playlists, library-songs, library-albums, library-playlists, library-music-videos, music-videos, stations).")
    var resourceType: String

    @Option(name: .customLong("id"), help: "Resource ID.")
    var id: String

    @Option(name: .customLong("l"), help: "Language tag override.")
    var language: String?

    func run() async throws {
        var args: [String: Value] = [
            "resourceType": .string(resourceType),
            "id": .string(id)
        ]
        if let language { args["l"] = .string(language) }
        try await runTool(toolName: "delete_rating", arguments: args)
    }
}

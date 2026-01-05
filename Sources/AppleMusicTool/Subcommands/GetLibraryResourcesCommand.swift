import ArgumentParser
import MCP

struct GetLibraryResourcesCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "get-library-resources",
        abstract: "Fetch library resources by type (songs, albums, artists, playlists, playlist-folders, music-videos)."
    )

    @OptionGroup var global: GlobalOptions

    @Option(name: .customLong("type"), help: "Library resource type.")
    var type: String

    @Option(name: .customLong("ids"), help: "Comma-separated IDs.")
    var ids: String?

    @Option(name: .customLong("limit"), help: "Limit.")
    var limit: Int?

    @Option(name: .customLong("offset"), help: "Offset.")
    var offset: Int?

    @Option(name: .customLong("filter-identity"), help: "filter[identity] value.")
    var filterIdentity: String?

    @Option(name: .customLong("include"), help: "Relationship data to include.")
    var include: String?

    @Option(name: .customLong("extend"), help: "Extended attributes to include.")
    var extend: String?

    @Option(name: .customLong("l"), help: "Language tag override.")
    var language: String?

    func run() async throws {
        var args: [String: Value] = ["type": .string(type)]
        if let ids { args["ids"] = .string(ids) }
        if let limit { args["limit"] = .int(limit) }
        if let offset { args["offset"] = .int(offset) }
        if let filterIdentity { args["filter[identity]"] = .string(filterIdentity) }
        if let include { args["include"] = .string(include) }
        if let extend { args["extend"] = .string(extend) }
        if let language { args["l"] = .string(language) }
        try await runTool(toolName: "get_library_resources", arguments: args)
    }
}

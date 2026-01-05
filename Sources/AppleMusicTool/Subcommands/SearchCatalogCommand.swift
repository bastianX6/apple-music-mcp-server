import ArgumentParser
import AppleMusicCore
import MCP

struct SearchCatalogCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "search-catalog",
        abstract: "Search Apple Music catalog by term."
    )

    @OptionGroup var global: GlobalOptions

    @Option(name: .customLong("term"), help: "Search term.")
    var term: String

    @Option(name: .customLong("types"), help: "Comma-separated resource types (default: songs,albums,artists,playlists).")
    var types: String?

    @Option(name: .customLong("limit"), help: "Result limit (1-25, default 10).")
    var limit: Int?

    @Option(name: .customLong("offset"), help: "Offset for pagination (default 0).")
    var offset: Int?

    @Option(name: .customLong("storefront"), help: "Storefront code (default: us; ignored when user token resolves storefront).")
    var storefront: String?

    @Option(name: .customLong("with"), help: "Additional resource types to include.")
    var withResources: String?

    @Option(name: .customLong("l"), help: "Language tag override.")
    var language: String?

    func run() async throws {
        var args: [String: Value] = ["term": .string(term)]
        if let types { args["types"] = .string(types) }
        if let limit { args["limit"] = .int(limit) }
        if let offset { args["offset"] = .int(offset) }
        if let storefront { args["storefront"] = .string(storefront) }
        if let withResources { args["with"] = .string(withResources) }
        if let language { args["l"] = .string(language) }

        try await runTool(toolName: "search_catalog", arguments: args)
    }
}

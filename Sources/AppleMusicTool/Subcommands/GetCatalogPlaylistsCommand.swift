import ArgumentParser
import MCP

struct GetCatalogPlaylistsCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "get-catalog-playlists",
        abstract: "Fetch catalog playlists by ids. Uses user storefront when available."
    )

    @OptionGroup var global: GlobalOptions

    @Option(name: .customLong("ids"), help: "Comma-separated playlist IDs.")
    var ids: String

    @Option(name: .customLong("storefront"), help: "Storefront code (default: us; ignored when user token resolves storefront).")
    var storefront: String?

    @Option(name: .customLong("include"), help: "Relationship data to include.")
    var include: String?

    @Option(name: .customLong("extend"), help: "Extended attributes to include.")
    var extend: String?

    @Option(name: .customLong("l"), help: "Language tag override.")
    var language: String?

    func run() async throws {
        var args: [String: Value] = ["ids": .string(ids)]
        if let storefront { args["storefront"] = .string(storefront) }
        if let include { args["include"] = .string(include) }
        if let extend { args["extend"] = .string(extend) }
        if let language { args["l"] = .string(language) }
        try await runTool(toolName: "get_catalog_playlists", arguments: args)
    }
}

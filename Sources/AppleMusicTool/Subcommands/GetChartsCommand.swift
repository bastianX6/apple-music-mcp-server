import ArgumentParser
import MCP

struct GetChartsCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "get-charts",
        abstract: "Fetch charts for a storefront (uses user storefront when available)."
    )

    @OptionGroup var global: GlobalOptions

    @Option(name: .customLong("storefront"), help: "Storefront code (default: us; ignored when user token resolves storefront).")
    var storefront: String?

    @Option(name: .customLong("types"), help: "Comma-separated chart types (songs,albums,playlists).")
    var types: String?

    @Option(name: .customLong("chart"), help: "Chart name (e.g., most-played).")
    var chart: String?

    @Option(name: .customLong("genre"), help: "Genre ID filter.")
    var genre: String?

    @Option(name: .customLong("limit"), help: "Limit per chart type (1-50, default 10).")
    var limit: Int?

    @Option(name: .customLong("offset"), help: "Offset for pagination (default 0).")
    var offset: Int?

    @Option(name: .customLong("with"), help: "Additional resource types to include.")
    var withResources: String?

    @Option(name: .customLong("l"), help: "Language tag override.")
    var language: String?

    func run() async throws {
        var args: [String: Value] = [:]
        if let storefront { args["storefront"] = .string(storefront) }
        if let types { args["types"] = .string(types) }
        if let chart { args["chart"] = .string(chart) }
        if let genre { args["genre"] = .string(genre) }
        if let limit { args["limit"] = .int(limit) }
        if let offset { args["offset"] = .int(offset) }
        if let withResources { args["with"] = .string(withResources) }
        if let language { args["l"] = .string(language) }
        try await runTool(toolName: "get_charts", arguments: args)
    }
}

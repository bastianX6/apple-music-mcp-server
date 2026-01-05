import ArgumentParser
import MCP

struct GetReplayDataCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "get-replay-data",
        abstract: "Fetch replay data via music-summaries."
    )

    @OptionGroup var global: GlobalOptions

    @Option(name: .customLong("filter-year"), help: "filter[year], must be latest.")
    var filterYear: String

    @Option(name: .customLong("views"), help: "Comma-separated views (top-artists, top-albums, top-songs).")
    var views: String?

    @Option(name: .customLong("include"), help: "Relationship data to include.")
    var include: String?

    @Option(name: .customLong("extend"), help: "Extended attributes to include.")
    var extend: String?

    @Option(name: .customLong("l"), help: "Language tag override.")
    var language: String?

    func run() async throws {
        var args: [String: Value] = ["filter[year]": .string(filterYear)]
        if let views { args["views"] = .string(views) }
        if let include { args["include"] = .string(include) }
        if let extend { args["extend"] = .string(extend) }
        if let language { args["l"] = .string(language) }
        try await runTool(toolName: "get_replay_data", arguments: args)
    }
}

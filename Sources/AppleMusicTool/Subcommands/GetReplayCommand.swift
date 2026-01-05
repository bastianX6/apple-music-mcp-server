import ArgumentParser
import MCP

struct GetReplayCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "get-replay",
        abstract: "Fetch replay data (alias of music-summaries)."
    )

    @OptionGroup var global: GlobalOptions

    @Option(name: .customLong("year"), help: "Replay year (only 'latest' is valid; defaults to latest).")
    var year: String?

    @Option(name: .customLong("views"), help: "Comma-separated views (top-artists, top-albums, top-songs).")
    var views: String?

    @Option(name: .customLong("include"), help: "Relationship data to include.")
    var include: String?

    @Option(name: .customLong("extend"), help: "Extended attributes to include.")
    var extend: String?

    @Option(name: .customLong("l"), help: "Language tag override.")
    var language: String?

    func validate() throws {
        if let year, year != "latest" {
            throw ValidationError("Invalid year \(year). Apple Music supports only 'latest' for replay.")
        }
    }

    func run() async throws {
        var args: [String: Value] = ["year": .string(year ?? "latest")]
        if let views { args["views"] = .string(views) }
        if let include { args["include"] = .string(include) }
        if let extend { args["extend"] = .string(extend) }
        if let language { args["l"] = .string(language) }
        try await runTool(toolName: "get_replay", arguments: args)
    }
}

import ArgumentParser
import MCP

struct GetLibrarySongsCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "get-library-songs",
        abstract: "Fetch user's library songs."
    )

    @OptionGroup var global: GlobalOptions

    @Option(name: .customLong("limit"), help: "Limit (1-100, default 25).")
    var limit: Int?

    @Option(name: .customLong("offset"), help: "Offset (default 0).")
    var offset: Int?

    @Option(name: .customLong("include"), help: "Relationship data to include.")
    var include: String?

    @Option(name: .customLong("extend"), help: "Extended attributes to include.")
    var extend: String?

    @Option(name: .customLong("l"), help: "Language tag override.")
    var language: String?

    func run() async throws {
        var args: [String: Value] = [:]
        if let limit { args["limit"] = .int(limit) }
        if let offset { args["offset"] = .int(offset) }
        if let include { args["include"] = .string(include) }
        if let extend { args["extend"] = .string(extend) }
        if let language { args["l"] = .string(language) }
        try await runTool(toolName: "get_library_songs", arguments: args)
    }
}

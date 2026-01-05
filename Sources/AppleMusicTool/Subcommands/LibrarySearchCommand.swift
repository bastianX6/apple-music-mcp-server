import ArgumentParser
import MCP

struct LibrarySearchCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "library-search",
        abstract: "Search user's library."
    )

    @OptionGroup var global: GlobalOptions

    @Option(name: .customLong("term"), help: "Search term.")
    var term: String

    @Option(name: .customLong("types"), help: "Comma-separated library resource types.")
    var types: String

    @Option(name: .customLong("limit"), help: "Limit (1-25, default 10).")
    var limit: Int?

    @Option(name: .customLong("offset"), help: "Offset (default 0).")
    var offset: Int?

    @Option(name: .customLong("l"), help: "Language tag override.")
    var language: String?

    func run() async throws {
        var args: [String: Value] = [
            "term": .string(term),
            "types": .string(types)
        ]
        if let limit { args["limit"] = .int(limit) }
        if let offset { args["offset"] = .int(offset) }
        if let language { args["l"] = .string(language) }
        try await runTool(toolName: "library_search", arguments: args)
    }
}

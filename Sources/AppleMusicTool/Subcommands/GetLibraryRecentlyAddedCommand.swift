import ArgumentParser
import MCP

struct GetLibraryRecentlyAddedCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "get-library-recently-added",
        abstract: "Fetch recently added library items."
    )

    @OptionGroup var global: GlobalOptions

    @Option(name: .customLong("limit"), help: "Result limit (1-100, default 25).")
    var limit: Int?

    @Option(name: .customLong("offset"), help: "Offset for pagination (default 0).")
    var offset: Int?

    @Option(name: .customLong("l"), help: "Language tag override.")
    var language: String?

    func run() async throws {
        var args: [String: Value] = [:]
        if let limit { args["limit"] = .int(limit) }
        if let offset { args["offset"] = .int(offset) }
        if let language { args["l"] = .string(language) }
        try await runTool(toolName: "get_library_recently_added", arguments: args)
    }
}

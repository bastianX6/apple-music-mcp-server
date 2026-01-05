import ArgumentParser
import MCP

struct GetLibraryRecentlyAddedCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "get-library-recently-added",
        abstract: "Fetch recently added library items."
    )

    @OptionGroup var global: GlobalOptions

    @Option(name: .customLong("l"), help: "Language tag override.")
    var language: String?

    func run() async throws {
        var args: [String: Value] = [:]
        if let language { args["l"] = .string(language) }
        try await runTool(toolName: "get_library_recently_added", arguments: args)
    }
}

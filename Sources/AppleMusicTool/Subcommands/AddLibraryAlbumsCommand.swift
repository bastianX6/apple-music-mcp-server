import ArgumentParser
import MCP

struct AddLibraryAlbumsCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "add-library-albums",
        abstract: "Add albums to library (may return 405)."
    )

    @OptionGroup var global: GlobalOptions

    @Option(name: .customLong("ids"), help: "Comma-separated album IDs.")
    var ids: String

    @Option(name: .customLong("l"), help: "Language tag override.")
    var language: String?

    func run() async throws {
        var args: [String: Value] = ["ids": .string(ids)]
        if let language { args["l"] = .string(language) }
        try await runTool(toolName: "add_library_albums", arguments: args)
    }
}

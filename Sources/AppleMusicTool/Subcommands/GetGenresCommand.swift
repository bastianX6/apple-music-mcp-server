import ArgumentParser
import MCP

struct GetGenresCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "get-genres",
        abstract: "Fetch catalog genres for a storefront (uses user storefront when available)."
    )

    @OptionGroup var global: GlobalOptions

    @Option(name: .customLong("storefront"), help: "Storefront code (default: us; ignored when user token resolves storefront).")
    var storefront: String?

    @Option(name: .customLong("l"), help: "Language tag override.")
    var language: String?

    func run() async throws {
        var args: [String: Value] = [:]
        if let storefront { args["storefront"] = .string(storefront) }
        if let language { args["l"] = .string(language) }
        try await runTool(toolName: "get_genres", arguments: args)
    }
}

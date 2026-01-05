import ArgumentParser
import MCP

struct GetSearchHintsCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "get-search-hints",
        abstract: "Get search hints for a term. Uses the user's storefront when available."
    )

    @OptionGroup var global: GlobalOptions

    @Option(name: .customLong("term"), help: "Partial search term.")
    var term: String

    @Option(name: .customLong("storefront"), help: "Storefront code (default: us; ignored when user token resolves storefront).")
    var storefront: String?

    @Option(name: .customLong("limit"), help: "Limit (1-25).")
    var limit: Int?

    @Option(name: .customLong("l"), help: "Language tag override.")
    var language: String?

    func run() async throws {
        var args: [String: Value] = ["term": .string(term)]
        if let storefront { args["storefront"] = .string(storefront) }
        if let limit { args["limit"] = .int(limit) }
        if let language { args["l"] = .string(language) }
        try await runTool(toolName: "get_search_hints", arguments: args)
    }
}

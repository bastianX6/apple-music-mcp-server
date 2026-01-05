import ArgumentParser
import MCP

struct GetSearchSuggestionsCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "get-search-suggestions",
        abstract: "Get search suggestions; defaults to kinds=terms. Uses user storefront when available."
    )

    @OptionGroup var global: GlobalOptions

    @Option(name: .customLong("term"), help: "Partial search term.")
    var term: String

    @Option(name: .customLong("storefront"), help: "Storefront code (default: us; ignored when user token resolves storefront).")
    var storefront: String?

    @Option(name: .customLong("kinds"), help: "Suggestion kinds (default: terms).")
    var kinds: String?

    @Option(name: .customLong("types"), help: "Comma-separated resource types to include.")
    var types: String?

    @Option(name: .customLong("limit"), help: "Limit (1-25).")
    var limit: Int?

    @Option(name: .customLong("l"), help: "Language tag override.")
    var language: String?

    func run() async throws {
        var args: [String: Value] = ["term": .string(term)]
        if let storefront { args["storefront"] = .string(storefront) }
        if let kinds { args["kinds"] = .string(kinds) }
        if let types { args["types"] = .string(types) }
        if let limit { args["limit"] = .int(limit) }
        if let language { args["l"] = .string(language) }
        try await runTool(toolName: "get_search_suggestions", arguments: args)
    }
}

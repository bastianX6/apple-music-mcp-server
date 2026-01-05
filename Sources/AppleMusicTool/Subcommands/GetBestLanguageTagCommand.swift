import ArgumentParser
import MCP

struct GetBestLanguageTagCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "get-best-language-tag",
        abstract: "Fetch best language tag for Accept-Language header. Uses user storefront when available."
    )

    @OptionGroup var global: GlobalOptions

    @Option(name: .customLong("acceptLanguage"), help: "Preferred language tag (e.g., es-ES).")
    var acceptLanguage: String

    @Option(name: .customLong("storefront"), help: "Storefront code (default: us; ignored when user token resolves storefront).")
    var storefront: String?

    @Option(name: .customLong("l"), help: "Language tag override.")
    var language: String?

    func run() async throws {
        var args: [String: Value] = ["acceptLanguage": .string(acceptLanguage)]
        if let storefront { args["storefront"] = .string(storefront) }
        if let language { args["l"] = .string(language) }
        try await runTool(toolName: "get_best_language_tag", arguments: args)
    }
}

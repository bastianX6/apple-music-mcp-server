import ArgumentParser
import MCP

struct GetCatalogMultiByTypeIdsCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "get-catalog-multi-by-type-ids",
        abstract: "Fetch multiple catalog resources by typed ids object. Uses user storefront when available."
    )

    @OptionGroup var global: GlobalOptions

    @Option(
        name: .customLong("ids"),
        parsing: .upToNextOption,
        help: "Repeatable key=value where key is resource type and value is CSV ids (e.g., --ids songs=1,2)."
    )
    var ids: [KeyValueArgument] = []

    @Option(name: .customLong("storefront"), help: "Storefront code (default: us; ignored when user token resolves storefront).")
    var storefront: String?

    @Option(name: .customLong("include"), help: "Relationship data to include.")
    var include: String?

    @Option(name: .customLong("extend"), help: "Extended attributes to include.")
    var extend: String?

    @Option(name: .customLong("l"), help: "Language tag override.")
    var language: String?

    func run() async throws {
        var idsObject: [String: Value] = [:]
        for pair in ids.sorted(by: { $0.key < $1.key }) {
            idsObject[pair.key] = .string(pair.value)
        }
        var args: [String: Value] = ["ids": .object(idsObject)]
        if let storefront { args["storefront"] = .string(storefront) }
        if let include { args["include"] = .string(include) }
        if let extend { args["extend"] = .string(extend) }
        if let language { args["l"] = .string(language) }
        try await runTool(toolName: "get_catalog_multi_by_type_ids", arguments: args)
    }
}

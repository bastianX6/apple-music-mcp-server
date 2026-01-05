import ArgumentParser
import MCP

struct GetCatalogRelationshipCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "get-catalog-relationship",
        abstract: "Fetch catalog relationship for a resource. Uses user storefront when available."
    )

    @OptionGroup var global: GlobalOptions

    @Option(name: .customLong("type"), help: "Resource type.")
    var type: String

    @Option(name: .customLong("id"), help: "Resource ID.")
    var id: String

    @Option(name: .customLong("relationship"), help: "Relationship name.")
    var relationship: String

    @Option(name: .customLong("limit"), help: "Limit.")
    var limit: Int?

    @Option(name: .customLong("offset"), help: "Offset.")
    var offset: Int?

    @Option(name: .customLong("storefront"), help: "Storefront code (default: us; ignored when user token resolves storefront).")
    var storefront: String?

    @Option(name: .customLong("include"), help: "Relationship data to include.")
    var include: String?

    @Option(name: .customLong("extend"), help: "Extended attributes to include.")
    var extend: String?

    @Option(name: .customLong("l"), help: "Language tag override.")
    var language: String?

    func run() async throws {
        var args: [String: Value] = [
            "type": .string(type),
            "id": .string(id),
            "relationship": .string(relationship)
        ]
        if let limit { args["limit"] = .int(limit) }
        if let offset { args["offset"] = .int(offset) }
        if let storefront { args["storefront"] = .string(storefront) }
        if let include { args["include"] = .string(include) }
        if let extend { args["extend"] = .string(extend) }
        if let language { args["l"] = .string(language) }
        try await runTool(toolName: "get_catalog_relationship", arguments: args)
    }
}

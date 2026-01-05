import ArgumentParser
import MCP

struct GetRecommendationRelationshipCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "get-recommendation-relationship",
        abstract: "Fetch a relationship for a recommendation."
    )

    @OptionGroup var global: GlobalOptions

    @Option(name: .customLong("id"), help: "Recommendation ID.")
    var id: String

    @Option(name: .customLong("relationship"), help: "Relationship name.")
    var relationship: String

    @Option(name: .customLong("limit"), help: "Limit.")
    var limit: Int?

    @Option(name: .customLong("offset"), help: "Offset.")
    var offset: Int?

    @Option(name: .customLong("include"), help: "Relationship data to include.")
    var include: String?

    @Option(name: .customLong("extend"), help: "Extended attributes to include.")
    var extend: String?

    @Option(name: .customLong("l"), help: "Language tag override.")
    var language: String?

    func validate() throws {
        guard Self.allowedRelationships.contains(relationship) else {
            let allowed = Self.allowedRelationships.sorted().joined(separator: ", ")
            throw ValidationError("Invalid relationship '\(relationship)'. Allowed: \(allowed).")
        }
    }

    func run() async throws {
        var args: [String: Value] = [
            "id": .string(id),
            "relationship": .string(relationship)
        ]
        if let limit { args["limit"] = .int(limit) }
        if let offset { args["offset"] = .int(offset) }
        if let include { args["include"] = .string(include) }
        if let extend { args["extend"] = .string(extend) }
        if let language { args["l"] = .string(language) }
        try await runTool(toolName: "get_recommendation_relationship", arguments: args)
    }

    private static let allowedRelationships: Set<String> = ["contents"]
}

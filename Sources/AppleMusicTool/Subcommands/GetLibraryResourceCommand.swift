import ArgumentParser
import MCP

struct GetLibraryResourceCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "get-library-resource",
        abstract: "Fetch a single library resource by type and id."
    )

    @OptionGroup var global: GlobalOptions

    @Option(name: .customLong("type"), help: "Library resource type.")
    var type: String

    @Option(name: .customLong("id"), help: "Library resource ID.")
    var id: String

    @Option(name: .customLong("include"), help: "Relationship data to include.")
    var include: String?

    @Option(name: .customLong("extend"), help: "Extended attributes to include.")
    var extend: String?

    @Option(name: .customLong("l"), help: "Language tag override.")
    var language: String?

    func run() async throws {
        var args: [String: Value] = ["type": .string(type), "id": .string(id)]
        if let include { args["include"] = .string(include) }
        if let extend { args["extend"] = .string(extend) }
        if let language { args["l"] = .string(language) }
        try await runTool(toolName: "get_library_resource", arguments: args)
    }
}

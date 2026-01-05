import ArgumentParser
import MCP

struct GetLibraryMultiByTypeIdsCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "get-library-multi-by-type-ids",
        abstract: "Fetch multiple library resources by typed ids object."
    )

    @OptionGroup var global: GlobalOptions

    @Option(
        name: .customLong("ids"),
        parsing: .upToNextOption,
        help: "Repeatable key=value where key is library type and value is CSV ids."
    )
    var ids: [KeyValueArgument] = []

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
        if let include { args["include"] = .string(include) }
        if let extend { args["extend"] = .string(extend) }
        if let language { args["l"] = .string(language) }
        try await runTool(toolName: "get_library_multi_by_type_ids", arguments: args)
    }
}

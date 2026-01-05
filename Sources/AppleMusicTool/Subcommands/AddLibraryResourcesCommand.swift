import ArgumentParser
import MCP

struct AddLibraryResourcesCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "add-library-resources",
        abstract: "Add resources to library using typed ids object or CSV with resourceType."
    )

    @OptionGroup var global: GlobalOptions

    @Option(
        name: .customLong("ids"),
        parsing: .upToNextOption,
        help: "Repeatable key=value where key is resource type and value is CSV ids (e.g., --ids songs=1,2)."
    )
    var ids: [KeyValueArgument] = []

    @Option(name: .customLong("ids-csv"), help: "CSV ids when used with --resource-type.")
    var idsCsv: String?

    @Option(name: .customLong("resource-type"), help: "Resource type when using --ids-csv (songs, albums, artists, music-videos, playlists, playlist-folders).")
    var resourceType: String?

    @Option(name: .customLong("l"), help: "Language tag override.")
    var language: String?

    func run() async throws {
        var args: [String: Value] = [:]
        if !ids.isEmpty {
            var idsObject: [String: Value] = [:]
            for pair in ids.sorted(by: { $0.key < $1.key }) {
                idsObject[pair.key] = .string(pair.value)
            }
            args["ids"] = .object(idsObject)
        }
        if let idsCsv { args["ids"] = .string(idsCsv) }
        if let resourceType { args["resourceType"] = .string(resourceType) }
        if let language { args["l"] = .string(language) }
        try await runTool(toolName: "add_library_resources", arguments: args)
    }
}

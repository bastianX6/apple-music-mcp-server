import ArgumentParser
import MCP

struct CreatePlaylistFolderCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "create-playlist-folder",
        abstract: "Create a library playlist folder."
    )

    @OptionGroup var global: GlobalOptions

    @Option(name: .customLong("name"), help: "Folder name.")
    var name: String

    func run() async throws {
        try await runTool(toolName: "create_playlist_folder", arguments: [
            "name": .string(name)
        ])
    }
}

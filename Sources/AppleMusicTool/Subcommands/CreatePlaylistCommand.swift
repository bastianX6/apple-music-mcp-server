import ArgumentParser
import MCP

struct CreatePlaylistCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "create-playlist",
        abstract: "Create a library playlist."
    )

    @OptionGroup var global: GlobalOptions

    @Option(name: .customLong("name"), help: "Playlist name.")
    var name: String

    @Option(name: .customLong("description"), help: "Playlist description.")
    var description: String?

    @Option(name: .customLong("tracks"), help: "Comma-separated track IDs (catalog songs).")
    var tracks: String?

    @Option(name: .customLong("parent"), help: "Parent folder ID (library-playlist-folders).")
    var parent: String?

    func run() async throws {
        var args: [String: Value] = ["name": .string(name)]
        if let description { args["description"] = .string(description) }
        if let tracks { args["tracks"] = .string(tracks) }
        if let parent { args["parent"] = .string(parent) }
        try await runTool(toolName: "create_playlist", arguments: args)
    }
}

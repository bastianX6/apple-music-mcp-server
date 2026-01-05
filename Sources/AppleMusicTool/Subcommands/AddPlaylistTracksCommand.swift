import ArgumentParser
import MCP

struct AddPlaylistTracksCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "add-playlist-tracks",
        abstract: "Add tracks to a library playlist."
    )

    @OptionGroup var global: GlobalOptions

    @Option(name: .customLong("playlist-id"), help: "Library playlist ID.")
    var playlistId: String

    @Option(name: .customLong("track-ids"), help: "Comma-separated track IDs (catalog or library songs).")
    var trackIds: String

    func run() async throws {
        try await runTool(toolName: "add_playlist_tracks", arguments: [
            "playlistId": .string(playlistId),
            "trackIds": .string(trackIds)
        ])
    }
}

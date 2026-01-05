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
        help: "Repeatable key=value where key is library type (library-songs, library-albums, library-artists, library-playlists, library-playlist-folders, library-music-videos) and value is CSV ids."
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
        var invalidKeys: [String] = []
        for pair in ids.sorted(by: { $0.key < $1.key }) {
            if let normalized = Self.normalizeLibraryTypeKey(pair.key) {
                idsObject[normalized] = .string(pair.value)
            } else {
                invalidKeys.append(pair.key)
            }
        }

        if !invalidKeys.isEmpty {
            let allowed = Self.libraryTypeKeys.sorted().joined(separator: ", ")
            throw ValidationError("Invalid ids keys: \(invalidKeys.joined(separator: ", ")). Allowed: \(allowed).")
        }
        var args: [String: Value] = ["ids": .object(idsObject)]
        if let include { args["include"] = .string(include) }
        if let extend { args["extend"] = .string(extend) }
        if let language { args["l"] = .string(language) }
        try await runTool(toolName: "get_library_multi_by_type_ids", arguments: args)
    }

    private static func normalizeLibraryTypeKey(_ raw: String) -> String? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return libraryTypeKeyMapping[trimmed]
    }

    private static let libraryTypeKeyMapping: [String: String] = [
        "library-songs": "library-songs",
        "library-albums": "library-albums",
        "library-artists": "library-artists",
        "library-playlists": "library-playlists",
        "library-playlist-folders": "library-playlist-folders",
        "library-music-videos": "library-music-videos",
        "songs": "library-songs",
        "albums": "library-albums",
        "artists": "library-artists",
        "playlists": "library-playlists",
        "playlist-folders": "library-playlist-folders",
        "music-videos": "library-music-videos"
    ]

    private static let libraryTypeKeys: Set<String> = [
        "library-songs",
        "library-albums",
        "library-artists",
        "library-playlists",
        "library-playlist-folders",
        "library-music-videos"
    ]
}

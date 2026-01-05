import ArgumentParser
import MCP

struct LibrarySearchCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "library-search",
        abstract: "Search user's library."
    )

    @OptionGroup var global: GlobalOptions

    @Option(name: .customLong("term"), help: "Search term.")
    var term: String

    @Option(name: .customLong("types"), help: "Comma-separated library resource types.")
    var types: String

    @Option(name: .customLong("limit"), help: "Limit (1-25, default 10).")
    var limit: Int?

    @Option(name: .customLong("offset"), help: "Offset (default 0).")
    var offset: Int?

    @Option(name: .customLong("l"), help: "Language tag override.")
    var language: String?

    func run() async throws {
        let rawTypes = types
            .split(separator: ",")
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        let normalization = normalizeLibraryTypes(rawTypes)
        if !normalization.invalid.isEmpty {
            let allowed = Self.libraryTypeKeys.sorted().joined(separator: ", ")
            throw ValidationError("Invalid types: \(normalization.invalid.joined(separator: ", ")). Allowed: \(allowed).")
        }
        let normalizedTypes = normalization.valid.joined(separator: ",")

        var args: [String: Value] = [
            "term": .string(term),
            "types": .string(normalizedTypes)
        ]
        if let limit { args["limit"] = .int(limit) }
        if let offset { args["offset"] = .int(offset) }
        if let language { args["l"] = .string(language) }
        try await runTool(toolName: "library_search", arguments: args)
    }

    private func normalizeLibraryTypes(_ raw: [String]) -> (valid: [String], invalid: [String]) {
        var valid: [String] = []
        var invalid: [String] = []
        for value in raw {
            guard let normalized = Self.libraryTypeKeyMapping[value] else {
                invalid.append(value)
                continue
            }
            if !valid.contains(normalized) {
                valid.append(normalized)
            }
        }
        return (valid, invalid)
    }

    private static let libraryTypeKeyMapping: [String: String] = [
        "library-songs": "library-songs",
        "library-albums": "library-albums",
        "library-artists": "library-artists",
        "library-playlists": "library-playlists",
        "library-music-videos": "library-music-videos",
        "songs": "library-songs",
        "albums": "library-albums",
        "artists": "library-artists",
        "playlists": "library-playlists",
        "music-videos": "library-music-videos"
    ]

    private static let libraryTypeKeys: Set<String> = [
        "library-songs",
        "library-albums",
        "library-artists",
        "library-playlists",
        "library-music-videos"
    ]
}

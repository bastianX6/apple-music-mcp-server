import ArgumentParser
import MCP

struct GetCatalogViewCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "get-catalog-view",
        abstract: "Fetch catalog view for a resource. Uses user storefront when available."
    )

    @OptionGroup var global: GlobalOptions

    @Option(name: .customLong("type"), help: "Resource type.")
    var type: String

    @Option(name: .customLong("id"), help: "Resource ID.")
    var id: String

    @Option(name: .customLong("view"), help: "View name.")
    var view: String

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

    func validate() throws {
        guard let allowedViews = Self.catalogViewsByType[type] else {
            let supported = Self.catalogViewsByType.keys.sorted().joined(separator: ", ")
            throw ValidationError("Type '\(type)' does not support views. Supported types: \(supported).")
        }
        guard allowedViews.contains(view) else {
            let allowed = allowedViews.sorted().joined(separator: ", ")
            throw ValidationError("Invalid view '\(view)' for type '\(type)'. Allowed views: \(allowed).")
        }
    }

    func run() async throws {
        var args: [String: Value] = [
            "type": .string(type),
            "id": .string(id),
            "view": .string(view)
        ]
        if let limit { args["limit"] = .int(limit) }
        if let offset { args["offset"] = .int(offset) }
        if let storefront { args["storefront"] = .string(storefront) }
        if let include { args["include"] = .string(include) }
        if let extend { args["extend"] = .string(extend) }
        if let language { args["l"] = .string(language) }
        try await runTool(toolName: "get_catalog_view", arguments: args)
    }

    private static let catalogViewsByType: [String: Set<String>] = [
        "albums": ["appears-on", "other-versions", "related-albums", "related-videos"],
        "artists": [
            "appears-on-albums",
            "compilation-albums",
            "featured-albums",
            "featured-music-videos",
            "featured-playlists",
            "full-albums",
            "latest-release",
            "live-albums",
            "similar-artists",
            "singles",
            "top-music-videos",
            "top-songs"
        ],
        "music-videos": ["more-by-artist", "more-in-genre"],
        "playlists": ["featured-artists", "more-by-curator"],
        "record-labels": ["latest-releases", "top-releases"]
    ]
}

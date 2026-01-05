import Foundation
import ArgumentParser
import MCP
import AppleMusicCore

struct GlobalOptions: ParsableArguments {
    @Option(name: .customLong("config"), help: "Path to config file (default: ~/Library/Application Support/apple-music-tool/config.json).")
    var configPath: String?

    @Flag(name: .customLong("beautify"), help: "Pretty-print JSON output.")
    var beautify: Bool = false
}

protocol ToolRunnableCommand {
    var global: GlobalOptions { get }
    func runTool(toolName: String, arguments: [String: Value]) async throws
}

extension ToolRunnableCommand {
    func runner() -> ToolRunner {
        ToolRunner(configPath: global.configPath, beautify: global.beautify)
    }

    func runTool(toolName: String, arguments: [String: Value]) async throws {
        try await runner().run(toolName: toolName, arguments: arguments)
    }
}

struct GetUserStorefrontCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(commandName: "get-user-storefront", abstract: "Return the user's storefront using the Music-User-Token.")

    @OptionGroup var global: GlobalOptions

    func run() async throws {
        try await runTool(toolName: "get_user_storefront", arguments: [:])
    }
}

struct SearchCatalogCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(commandName: "search-catalog", abstract: "Search Apple Music catalog by term.")

    @OptionGroup var global: GlobalOptions

    @Option(name: .customLong("term"), help: "Search term.")
    var term: String

    @Option(name: .customLong("types"), help: "Comma-separated resource types (default: songs,albums,artists,playlists).")
    var types: String?

    @Option(name: .customLong("limit"), help: "Result limit (1-25, default 10).")
    var limit: Int?

    @Option(name: .customLong("offset"), help: "Offset for pagination (default 0).")
    var offset: Int?

    @Option(name: .customLong("storefront"), help: "Storefront code (default: us; ignored when user token resolves storefront).")
    var storefront: String?

    @Option(name: .customLong("with"), help: "Additional resource types to include.")
    var withResources: String?

    @Option(name: .customLong("l"), help: "Language tag override.")
    var language: String?

    func run() async throws {
        var args: [String: Value] = ["term": .string(term)]
        if let types { args["types"] = .string(types) }
        if let limit { args["limit"] = .int(limit) }
        if let offset { args["offset"] = .int(offset) }
        if let storefront { args["storefront"] = .string(storefront) }
        if let withResources { args["with"] = .string(withResources) }
        if let language { args["l"] = .string(language) }

        try await runTool(toolName: "search_catalog", arguments: args)
    }
}

struct GetRecordLabelsCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(commandName: "get-record-labels", abstract: "Informative error placeholder for record labels endpoint.")

    @OptionGroup var global: GlobalOptions

    func run() async throws {
        try await runTool(toolName: "get_record_labels", arguments: [:])
    }
}

struct GetLibraryPlaylistsCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(commandName: "get-library-playlists", abstract: "Fetch user's library playlists.")

    @OptionGroup var global: GlobalOptions

    @Option(name: .customLong("limit"), help: "Limit (1-100, default 25).")
    var limit: Int?

    @Option(name: .customLong("offset"), help: "Offset (default 0).")
    var offset: Int?

    @Option(name: .customLong("include"), help: "Relationship data to include.")
    var include: String?

    @Option(name: .customLong("extend"), help: "Extended attributes to include.")
    var extend: String?

    @Option(name: .customLong("l"), help: "Language tag override.")
    var language: String?

    func run() async throws {
        var args: [String: Value] = [:]
        if let limit { args["limit"] = .int(limit) }
        if let offset { args["offset"] = .int(offset) }
        if let include { args["include"] = .string(include) }
        if let extend { args["extend"] = .string(extend) }
        if let language { args["l"] = .string(language) }
        try await runTool(toolName: "get_library_playlists", arguments: args)
    }
}

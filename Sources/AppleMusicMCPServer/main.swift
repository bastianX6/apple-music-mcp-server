import ArgumentParser
import Foundation
import MCP

@main
struct AppleMusicMCPServerMain: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Apple Music MCP Server",
        subcommands: [Run.self, Setup.self],
        defaultSubcommand: Run.self
    )

    struct Run: AsyncParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Start the MCP server.")

        @Option(name: .customLong("config"), help: "Path to a JSON config file (default: ~/Library/Application Support/apple-music-mcp/config.json).")
        var configPath: String?

        func run() async throws {
            let bootstrap = ServerBootstrap(configPath: configPath)
            try await bootstrap.start()
        }
    }

    struct Setup: AsyncParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Persist a Music-User-Token (CLI or browser helper).")

        @Option(name: .customLong("token"), help: "Music-User-Token to persist (CLI mode).")
        var token: String?

        @Flag(name: .customLong("serve"), help: "Start local HTTP server and open browser for MusicKit JS flow.")
        var serve: Bool = false

        @Option(name: .customLong("port"), help: "Port for the local HTTP server (default: 3000).")
        var port: UInt16?

        @Option(name: .customLong("config"), help: "Path to config file (default: ~/Library/Application Support/apple-music-mcp/config.json).")
        var configPath: String?

        func run() async throws {
            let coordinator = SetupCoordinator(configPath: configPath)
            if serve {
                try await coordinator.runServerFlow(port: port ?? 3000)
            } else {
                try await coordinator.runCLIFlow(token: token)
            }
        }
    }
}

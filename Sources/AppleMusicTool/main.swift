import ArgumentParser
import Foundation
import AppleMusicCore

@main
struct AppleMusicToolMain: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Apple Music CLI",
        subcommands: [Setup.self],
        helpNames: [.long, .short]
    )

    init() {}

    struct Setup: AsyncParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Persist a Music-User-Token (CLI or browser helper).")

        @Option(name: .customLong("token"), help: "Music-User-Token to persist (CLI mode).")
        var token: String?

        @Flag(name: .customLong("serve"), help: "Start local HTTP server and open browser for MusicKit JS flow.")
        var serve: Bool = false

        @Option(name: .customLong("port"), help: "Port for the local HTTP server (default: 3000).")
        var port: UInt16?

        @Option(name: .customLong("config"), help: "Path to config file (default: ~/Library/Application Support/apple-music-tool/config.json).")
        var configPath: String?

        func run() async throws {
            let coordinator = SetupCoordinator(
                configPath: configPath,
                defaultConfigPath: "~/Library/Application Support/apple-music-tool/config.json"
            )
            if serve {
                try await coordinator.runServerFlow(port: port ?? 3000)
            } else {
                try await coordinator.runCLIFlow(token: token)
            }
        }
    }
}

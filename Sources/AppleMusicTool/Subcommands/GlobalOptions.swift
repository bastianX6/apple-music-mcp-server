import ArgumentParser
import MCP

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

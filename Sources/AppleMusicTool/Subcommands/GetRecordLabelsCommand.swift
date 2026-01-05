import ArgumentParser
import AppleMusicCore
import MCP

struct GetRecordLabelsCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "get-record-labels",
        abstract: "Informative error placeholder for record labels endpoint."
    )

    @OptionGroup var global: GlobalOptions

    func run() async throws {
        try await runTool(toolName: "get_record_labels", arguments: [:])
    }
}

import ArgumentParser
import AppleMusicCore
import MCP

struct GetUserStorefrontCommand: AsyncParsableCommand, ToolRunnableCommand {
    static let configuration = CommandConfiguration(
        commandName: "get-user-storefront",
        abstract: "Return the user's storefront using the Music-User-Token."
    )

    @OptionGroup var global: GlobalOptions

    func run() async throws {
        try await runTool(toolName: "get_user_storefront", arguments: [:])
    }
}

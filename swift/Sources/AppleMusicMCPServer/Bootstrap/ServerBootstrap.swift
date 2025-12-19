import Foundation
import MCP
import Logging

struct ServerBootstrap {
    private let configLoader = ConfigLoader()
    private let tokenProviders = TokenProviders()
    private let toolRegistryFactory: (AppleMusicClientProtocol) -> ToolRegistry

    init(toolRegistryFactory: @escaping (AppleMusicClientProtocol) -> ToolRegistry = { ToolRegistry(client: $0) }) {
        self.toolRegistryFactory = toolRegistryFactory
    }

    func start() async throws {
        let config = try configLoader.load()
        let developerToken = try tokenProviders.developer.token(using: config)
        let userToken = tokenProviders.user.token(using: config)

        // Create the shared Apple Music client for tool handlers.
        let client: AppleMusicClientProtocol = AppleMusicClient(developerToken: developerToken, userToken: userToken)
        let server = Server(
            name: "AppleMusicMCPServer",
            version: "0.1.0",
            capabilities: .init(tools: .init(listChanged: true))
        )

        let registry = toolRegistryFactory(client)
        await registry.register(on: server)

        let logger = Logger(label: "com.apple-music-mcp-server")
        let transport = StdioTransport(logger: logger)

        try await server.start(transport: transport)
    }
}

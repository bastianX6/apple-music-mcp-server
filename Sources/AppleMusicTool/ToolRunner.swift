import Foundation
import ArgumentParser
import MCP
import AppleMusicCore

struct ToolRunner {
    let configPath: String?
    let beautify: Bool
    let clientOverride: AppleMusicClientProtocol?
    let stdout: (String) -> Void
    let stderr: (String) -> Void

    init(
        configPath: String?,
        beautify: Bool,
        client: AppleMusicClientProtocol? = nil,
        stdout: @escaping (String) -> Void = { print($0) },
        stderr: @escaping (String) -> Void = { FileHandle.standardError.write(Data(($0 + "\n").utf8)) }
    ) {
        self.configPath = configPath
        self.beautify = beautify
        self.clientOverride = client
        self.stdout = stdout
        self.stderr = stderr
    }

    func run(toolName: String, arguments: [String: Value]) async throws {
        let client = try await buildClient()
        let registry = ToolRegistry(client: client)
        let params = CallTool.Parameters(name: toolName, arguments: arguments)
        let result = try await registry.callTool(params: params)
        let rendered = try render(result: result, beautify: beautify)

        if result.isError == true {
            stderr(rendered)
            throw ExitCode.failure
        } else {
            stdout(rendered)
        }
    }

    private func buildClient() async throws -> AppleMusicClientProtocol {
        if let clientOverride {
            return clientOverride
        }

        let appPaths = AppPaths(
            appName: "apple-music-tool",
            defaultConfigPath: "~/Library/Application Support/apple-music-tool/config.json",
            logsDirectory: "~/Library/Application Support/apple-music-tool/logs"
        )
        let loader = ConfigLoader(configPath: configPath, defaultConfigPath: appPaths.defaultConfigPath)
        let config = try await loader.load()
        let tokens = TokenProviders()
        let developerToken = try tokens.developer.token(using: config)
        let userToken = tokens.user.token(using: config)
        return AppleMusicClient(developerToken: developerToken, userToken: userToken)
    }

    private func render(result: CallTool.Result, beautify: Bool) throws -> String {
        let text = result.content.compactMap { content -> String? in
            if case let .text(value) = content { return value }
            return nil
        }.joined(separator: "\n")

        if result.isError == true {
            return try renderErrorEnvelope(message: text, beautify: beautify)
        }

        guard let data = text.data(using: .utf8), let json = try? JSONSerialization.jsonObject(with: data) else {
            return text
        }
        let options: JSONSerialization.WritingOptions = beautify ? [.prettyPrinted] : []
        let out = try JSONSerialization.data(withJSONObject: json, options: options)
        return String(data: out, encoding: .utf8) ?? text
    }

    private func renderErrorEnvelope(message: String, beautify: Bool) throws -> String {
        let envelope: [String: Any] = [
            "error": [
                "type": "tool-error",
                "message": message
            ]
        ]
        let data = try JSONSerialization.data(withJSONObject: envelope, options: beautify ? [.prettyPrinted] : [])
        return String(data: data, encoding: .utf8) ?? message
    }
}

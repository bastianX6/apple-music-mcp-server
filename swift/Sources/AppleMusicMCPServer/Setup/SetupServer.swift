import Foundation
import Network
#if canImport(AppKit)
import AppKit
#endif

final class SetupServer: @unchecked Sendable {
    private let port: NWEndpoint.Port
    private let developerToken: String
    private let tokenHandler: (String) -> Void
    private var listener: NWListener?
    private let queue = DispatchQueue(label: "setup-server")

    init(port: UInt16 = 3000, developerToken: String, tokenHandler: @escaping (String) -> Void) throws {
        guard let nwPort = NWEndpoint.Port(rawValue: port) else {
            throw NSError(domain: "SetupServer", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid port"])
        }
        self.port = nwPort
        self.developerToken = developerToken
        self.tokenHandler = tokenHandler
    }

    func start() throws {
        let listener = try NWListener(using: .tcp, on: port)
        self.listener = listener

        listener.newConnectionHandler = { [weak self] connection in
            self?.handle(connection: connection)
        }

        listener.start(queue: queue)
    }

    func stop() {
        listener?.cancel()
        listener = nil
    }

    func openInBrowser() {
        #if canImport(AppKit)
        let url = URL(string: "http://127.0.0.1:\(port.rawValue)/")!
        NSWorkspace.shared.open(url)
        #endif
    }

    private func handle(connection: NWConnection) {
        connection.start(queue: queue)
        connection.receive(minimumIncompleteLength: 1, maximumLength: 64 * 1024) { [weak self] data, _, _, error in
            guard let self, let data, error == nil else {
                connection.cancel()
                return
            }

            let request = String(decoding: data, as: UTF8.self)
            let (requestLine, headers, body) = self.parseHTTPRequest(request)

            if requestLine.hasPrefix("GET / ") {
                self.respondWithIndexHTML(connection: connection)
            } else if requestLine.hasPrefix("POST /token") {
                let token = self.extractToken(from: body, contentType: headers["content-type"])
                if let token {
                    self.tokenHandler(token)
                }
                self.respond(text: "ok", connection: connection)
            } else {
                self.respondNotFound(connection: connection)
            }
        }
    }

    private func respondWithIndexHTML(connection: NWConnection) {
        let htmlData = SetupServer.renderIndexHTML(developerToken: developerToken) ?? Data("Missing page".utf8)
        let headers = "HTTP/1.1 200 OK\r\nContent-Type: text/html; charset=utf-8\r\nContent-Length: \(htmlData.count)\r\nConnection: close\r\n\r\n"
        let prefix = Data(headers.utf8)
        connection.send(content: prefix + htmlData, completion: .contentProcessed { _ in
            connection.cancel()
        })
    }

    private func respond(text: String, connection: NWConnection) {
        let body = Data(text.utf8)
        let headers = "HTTP/1.1 200 OK\r\nContent-Type: text/plain; charset=utf-8\r\nContent-Length: \(body.count)\r\nConnection: close\r\n\r\n"
        let prefix = Data(headers.utf8)
        connection.send(content: prefix + body, completion: .contentProcessed { _ in
            connection.cancel()
        })
    }

    private func respondNotFound(connection: NWConnection) {
        let body = Data("Not Found".utf8)
        let headers = "HTTP/1.1 404 Not Found\r\nContent-Type: text/plain; charset=utf-8\r\nContent-Length: \(body.count)\r\nConnection: close\r\n\r\n"
        let prefix = Data(headers.utf8)
        connection.send(content: prefix + body, completion: .contentProcessed { _ in
            connection.cancel()
        })
    }

    private func parseHTTPRequest(_ request: String) -> (String, [String: String], String) {
        let sections = request.components(separatedBy: "\r\n\r\n")
        let head = sections.first ?? ""
        let body = sections.dropFirst().joined(separator: "\r\n\r\n")
        let lines = head.components(separatedBy: "\r\n")
        let requestLine = lines.first ?? ""
        var headers: [String: String] = [:]
        for line in lines.dropFirst() {
            let parts = line.split(separator: ":", maxSplits: 1).map(String.init)
            if parts.count == 2 {
                headers[parts[0].lowercased()] = parts[1].trimmingCharacters(in: .whitespaces)
            }
        }
        return (requestLine, headers, body)
    }

    private func extractToken(from body: String, contentType: String?) -> String? {
        let trimmed = body.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.isEmpty == false else { return nil }

        if let contentType, contentType.contains("application/json"),
           let data = trimmed.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            if let token = json["token"] as? String { return token }
            if let token = json["userToken"] as? String { return token }
        }

        if let decoded = trimmed.removingPercentEncoding, decoded.isEmpty == false {
            return decoded
        }
        return trimmed
    }

    static func renderIndexHTML(developerToken: String) -> Data? {
        guard let url = Bundle.module.url(forResource: "index", withExtension: "html", subdirectory: "SetupPage") else {
            return nil
        }
        guard let template = try? String(contentsOf: url, encoding: .utf8) else { return nil }

        let appName = "AppleMusicMCPServer"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "dev"

        let rendered = template
            .replacingOccurrences(of: "__DEVELOPER_TOKEN__", with: developerToken)
            .replacingOccurrences(of: "__APP_NAME__", with: appName)
            .replacingOccurrences(of: "__APP_BUILD__", with: build)

        return rendered.data(using: .utf8)
    }
}

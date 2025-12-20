import Foundation
@preconcurrency import NIOCore
@preconcurrency import NIOHTTP1
@preconcurrency import NIOPosix
#if canImport(AppKit)
import AppKit
#endif

final class SetupServer: @unchecked Sendable {
    private let port: Int
    private let developerToken: String
    private let tokenHandler: @Sendable (String) -> Void

    private var group: EventLoopGroup?
    private var channel: Channel?

    init(port: UInt16 = 3000, developerToken: String, tokenHandler: @escaping @Sendable (String) -> Void) {
        self.port = Int(port)
        self.developerToken = developerToken
        self.tokenHandler = tokenHandler
    }

    func start() throws {
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        self.group = group

        let developerToken = self.developerToken
        let tokenHandler = self.tokenHandler

        let bootstrap = NIOPosix.ServerBootstrap(group: group)
            .serverChannelOption(.backlog, value: 256)
            .serverChannelOption(.socketOption(.so_reuseaddr), value: 1)
            .childChannelInitializer { channel in
                channel.pipeline.configureHTTPServerPipeline(withErrorHandling: true).flatMap {
                    channel.pipeline.addHandler(SetupHTTPHandler(
                        developerToken: developerToken,
                        tokenHandler: tokenHandler
                    ))
                }
            }
            .childChannelOption(.socketOption(.so_reuseaddr), value: 1)

        self.channel = try bootstrap.bind(host: "127.0.0.1", port: port).wait()
    }

    func stop() {
        do {
            try channel?.close().wait()
        } catch {
            // best-effort close
        }
        channel = nil

        if let group {
            try? group.syncShutdownGracefully()
        }
        self.group = nil
    }

    func openInBrowser() {
        let url = URL(string: "http://127.0.0.1:\(port)/")!

        #if canImport(AppKit)
        NSWorkspace.shared.open(url)
        #else
        let fm = FileManager.default
        let candidates = ["/usr/bin/open", "/usr/bin/xdg-open", "/bin/xdg-open"]
        guard let opener = candidates.first(where: { fm.isExecutableFile(atPath: $0) }) else {
            print("Open \(url.absoluteString) in your browser to continue the setup flow.")
            return
        }

        let process = Process()
        process.executableURL = URL(fileURLWithPath: opener)
        process.arguments = [url.absoluteString]
        try? process.run()
        #endif
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

private final class SetupHTTPHandler: ChannelInboundHandler, @unchecked Sendable {
    typealias InboundIn = HTTPServerRequestPart
    typealias OutboundOut = HTTPServerResponsePart

    private let developerToken: String
    private let tokenHandler: @Sendable (String) -> Void

    private var requestHead: HTTPRequestHead?
    private var bodyBuffer: ByteBuffer?

    init(developerToken: String, tokenHandler: @escaping @Sendable (String) -> Void) {
        self.developerToken = developerToken
        self.tokenHandler = tokenHandler
    }

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let part = unwrapInboundIn(data)

        switch part {
        case .head(let head):
            requestHead = head
            bodyBuffer = context.channel.allocator.buffer(capacity: 0)
        case .body(var buffer):
            bodyBuffer?.writeBuffer(&buffer)
        case .end:
            handleRequest(context: context)
        }
    }

    func errorCaught(context: ChannelHandlerContext, error: Error) {
        context.close(promise: nil)
    }

    private func handleRequest(context: ChannelHandlerContext) {
        guard let head = requestHead else {
            sendResponse(
                context: context,
                status: .badRequest,
                contentType: "text/plain; charset=utf-8",
                body: Data("Bad Request".utf8)
            )
            return
        }

        switch (head.method, head.uri) {
        case (.GET, "/"):
            let html = SetupServer.renderIndexHTML(developerToken: developerToken) ?? Data("Missing page".utf8)
            sendResponse(context: context, status: .ok, contentType: "text/html; charset=utf-8", body: html)

        case (.POST, let uri) where uri == "/token":
            let contentType = head.headers.first(name: "content-type")
            let bodyString = bodyBuffer.flatMap { buffer -> String? in
                var copy = buffer
                return copy.readString(length: copy.readableBytes)
            }
            if let token = extractToken(from: bodyString ?? "", contentType: contentType) {
                tokenHandler(token)
            }
            sendResponse(context: context, status: .ok, contentType: "text/plain; charset=utf-8", body: Data("ok".utf8))

        default:
            sendResponse(context: context, status: .notFound, contentType: "text/plain; charset=utf-8", body: Data("Not Found".utf8))
        }
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

    private func sendResponse(context: ChannelHandlerContext, status: HTTPResponseStatus, contentType: String, body: Data) {
        let version = requestHead?.version ?? HTTPVersion(major: 1, minor: 1)
        var headers = HTTPHeaders()
        headers.add(name: "Content-Length", value: "\(body.count)")
        headers.add(name: "Content-Type", value: contentType)
        headers.add(name: "Connection", value: "close")

        let head = HTTPResponseHead(version: version, status: status, headers: headers)
        context.write(wrapOutboundOut(.head(head)), promise: nil)

        var buffer = context.channel.allocator.buffer(capacity: body.count)
        buffer.writeBytes(body)
        context.write(wrapOutboundOut(.body(.byteBuffer(buffer))), promise: nil)

        let flushFuture = context.writeAndFlush(wrapOutboundOut(.end(nil)))
        let channel = context.channel
        let eventLoop = context.eventLoop
        flushFuture.whenComplete { _ in
            eventLoop.execute {
                channel.close(promise: nil)
            }
        }
    }
}

// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AppleMusicMCPServer",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "AppleMusicMCPServer", targets: ["AppleMusicMCPServer"])
    ],
    dependencies: [
        .package(url: "https://github.com/modelcontextprotocol/swift-sdk.git", from: "0.10.0"),
        .package(url: "https://github.com/Kitura/Swift-JWT.git", from: "4.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.0"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.70.0")
    ],
    targets: [
        .executableTarget(
            name: "AppleMusicMCPServer",
            dependencies: [
                .product(name: "MCP", package: "swift-sdk"),
                .product(name: "SwiftJWT", package: "Swift-JWT"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio")
            ],
            path: "Sources/AppleMusicMCPServer",
            resources: [
                .copy("Resources/SetupPage")
            ],
            swiftSettings: [
                .unsafeFlags(["-parse-as-library"], .when(platforms: [.macOS]))
            ]
        ),
        .testTarget(
            name: "AppleMusicMCPServerTests",
            dependencies: ["AppleMusicMCPServer"],
            path: "Tests/AppleMusicMCPServerTests"
        )
    ]
)

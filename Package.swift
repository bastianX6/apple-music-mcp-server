// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AppleMusicMCPServer",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .executable(name: "apple-music-mcp", targets: ["AppleMusicMCPServer"]),
        .executable(name: "apple-music-tool", targets: ["AppleMusicTool"])
    ],
    dependencies: [
        .package(url: "https://github.com/modelcontextprotocol/swift-sdk.git", from: "0.10.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.0"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.70.0"),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "3.9.0"),
        .package(url: "https://github.com/apple/swift-configuration.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "AppleMusicCore",
            dependencies: [
                .product(name: "MCP", package: "swift-sdk"),
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "Configuration", package: "swift-configuration")
            ],
            path: "Sources/AppleMusicCore",
            resources: [
                .copy("Resources/SetupPage")
            ],
            swiftSettings: [
                .unsafeFlags(["-parse-as-library"])
            ]
        ),
        .executableTarget(
            name: "AppleMusicMCPServer",
            dependencies: [
                "AppleMusicCore",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "MCP", package: "swift-sdk"),
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio")
            ],
            path: "Sources/AppleMusicMCPServer",
            swiftSettings: [
                .unsafeFlags(["-parse-as-library"])
            ]
        ),
        .executableTarget(
            name: "AppleMusicTool",
            dependencies: [
                "AppleMusicCore",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "MCP", package: "swift-sdk"),
                .product(name: "Configuration", package: "swift-configuration")
            ],
            path: "Sources/AppleMusicTool",
            swiftSettings: [
                .unsafeFlags(["-parse-as-library"])
            ]
        ),
        .testTarget(
            name: "AppleMusicMCPServerTests",
            dependencies: ["AppleMusicCore"],
            path: "Tests/AppleMusicMCPServerTests"
        )
    ]
)

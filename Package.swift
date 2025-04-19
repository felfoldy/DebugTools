// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DebugTools",
    platforms: [.iOS(.v16), .macOS(.v14), .visionOS(.v1)],
    products: [
        .library(
            name: "DebugTools",
            targets: ["DebugTools"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/felfoldy/LogTools.git", from: "1.1.0"),
    ],
    targets: [
        .target(
            name: "DebugTools",
            dependencies: ["LogTools"]
        ),
        .testTarget(
            name: "DebugToolsTests",
            dependencies: ["DebugTools"]
        ),
    ]
)

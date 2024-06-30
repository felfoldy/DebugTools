// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DebugTools",
    platforms: [.iOS(.v16), .macOS(.v14)],
    products: [
        .library(
            name: "DebugTools",
            targets: ["DebugTools"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DebugTools",
            dependencies: []
        ),
        .testTarget(
            name: "DebugToolsTests",
            dependencies: ["DebugTools"]
        ),
    ]
)

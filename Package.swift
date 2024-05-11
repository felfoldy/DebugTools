// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DebugTools",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "DebugTools",
            targets: ["DebugTools"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", .upToNextMajor(from: "2.0.0")),
    ],
    targets: [
        .target(
            name: "DebugTools",
            dependencies: ["SwiftyBeaver"]
        ),
        .testTarget(
            name: "DebugToolsTests",
            dependencies: ["DebugTools"]
        ),
    ]
)

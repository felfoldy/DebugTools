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
        .package(url: "https://github.com/nkristek/Highlight.git", branch: "master"),
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.2.0"),
    ],
    targets: [
        .target(
            name: "DebugTools",
            dependencies: [
                .byName(name: "Highlight"),
                .product(name: "Algorithms", package: "swift-algorithms"),
            ]
        ),
        .testTarget(
            name: "DebugToolsTests",
            dependencies: ["DebugTools"]
        ),
    ]
)

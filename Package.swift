// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Storage",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "Storage",
            targets: ["Storage"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Storage",
            dependencies: []
        ),
        .testTarget(
            name: "StorageTests",
            dependencies: [
                "Storage"
            ]
        )
    ]
)

// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PuzzleShape",
    platforms: [
        .macOS(.v10_14),
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PuzzleShape",
            targets: ["PuzzleShape"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PuzzleShape",
            resources: [ .process("Media.xcassets")]),
        .testTarget(
            name: "PuzzleShapeTests",
            dependencies: ["PuzzleShape"]
        ),
    ]
)

// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LiquidGlassKit",
    platforms: [
        .iOS(.v26),
        .macOS(.v26)
    ],
    products: [
        .library(
            name: "LiquidGlassKit",
            targets: ["LiquidGlassKit"]
        ),
    ],
    targets: [
        .target(
            name: "LiquidGlassKit",
            path: "Sources/LiquidGlassKit",
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals"),
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "LiquidGlassKitTests",
            dependencies: ["LiquidGlassKit"]
        ),
    ]
)

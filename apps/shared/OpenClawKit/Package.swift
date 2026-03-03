// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "OpenHandKit",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    products: [
        .library(name: "OpenHandProtocol", targets: ["OpenHandProtocol"]),
        .library(name: "OpenHandKit", targets: ["OpenHandKit"]),
        .library(name: "OpenHandChatUI", targets: ["OpenHandChatUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/steipete/ElevenLabsKit", exact: "0.1.0"),
        .package(url: "https://github.com/gonzalezreal/textual", exact: "0.3.1"),
    ],
    targets: [
        .target(
            name: "OpenHandProtocol",
            path: "Sources/OpenHandProtocol",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "OpenHandKit",
            dependencies: [
                "OpenHandProtocol",
                .product(name: "ElevenLabsKit", package: "ElevenLabsKit"),
            ],
            path: "Sources/OpenHandKit",
            resources: [
                .process("Resources"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "OpenHandChatUI",
            dependencies: [
                "OpenHandKit",
                .product(
                    name: "Textual",
                    package: "textual",
                    condition: .when(platforms: [.macOS, .iOS])),
            ],
            path: "Sources/OpenHandChatUI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "OpenHandKitTests",
            dependencies: ["OpenHandKit", "OpenHandChatUI"],
            path: "Tests/OpenHandKitTests",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])

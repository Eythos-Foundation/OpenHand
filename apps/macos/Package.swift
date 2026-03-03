// swift-tools-version: 6.2
// Package manifest for the OpenHand macOS companion (menu bar app + IPC library).

import PackageDescription

let package = Package(
    name: "OpenHand",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .library(name: "OpenHandIPC", targets: ["OpenHandIPC"]),
        .library(name: "OpenHandDiscovery", targets: ["OpenHandDiscovery"]),
        .executable(name: "OpenHand", targets: ["OpenHand"]),
        .executable(name: "openhand-mac", targets: ["OpenHandMacCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/MenuBarExtraAccess", exact: "1.2.2"),
        .package(url: "https://github.com/swiftlang/swift-subprocess.git", from: "0.1.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.8.0"),
        .package(url: "https://github.com/sparkle-project/Sparkle", from: "2.8.1"),
        .package(url: "https://github.com/steipete/Peekaboo.git", branch: "main"),
        .package(path: "../shared/OpenHandKit"),
        .package(path: "../../Swabble"),
    ],
    targets: [
        .target(
            name: "OpenHandIPC",
            dependencies: [],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "OpenHandDiscovery",
            dependencies: [
                .product(name: "OpenHandKit", package: "OpenHandKit"),
            ],
            path: "Sources/OpenHandDiscovery",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .executableTarget(
            name: "OpenHand",
            dependencies: [
                "OpenHandIPC",
                "OpenHandDiscovery",
                .product(name: "OpenHandKit", package: "OpenHandKit"),
                .product(name: "OpenHandChatUI", package: "OpenHandKit"),
                .product(name: "OpenHandProtocol", package: "OpenHandKit"),
                .product(name: "SwabbleKit", package: "swabble"),
                .product(name: "MenuBarExtraAccess", package: "MenuBarExtraAccess"),
                .product(name: "Subprocess", package: "swift-subprocess"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Sparkle", package: "Sparkle"),
                .product(name: "PeekabooBridge", package: "Peekaboo"),
                .product(name: "PeekabooAutomationKit", package: "Peekaboo"),
            ],
            exclude: [
                "Resources/Info.plist",
            ],
            resources: [
                .copy("Resources/OpenHand.icns"),
                .copy("Resources/DeviceModels"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .executableTarget(
            name: "OpenHandMacCLI",
            dependencies: [
                "OpenHandDiscovery",
                .product(name: "OpenHandKit", package: "OpenHandKit"),
                .product(name: "OpenHandProtocol", package: "OpenHandKit"),
            ],
            path: "Sources/OpenHandMacCLI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "OpenHandIPCTests",
            dependencies: [
                "OpenHandIPC",
                "OpenHand",
                "OpenHandDiscovery",
                .product(name: "OpenHandProtocol", package: "OpenHandKit"),
                .product(name: "SwabbleKit", package: "swabble"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])

// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Shell",
    platforms: [ .iOS(.v13), .macOS(.v11) ],
    products: [
        .library(name: "Shared", targets: ["Shared"]),
        .library(name: "EnterName", targets: ["EnterName"]),
        .library(name: "Paywall", targets: ["Paywall"])
    ],
    dependencies: [
        .package(path: "Core"),
    ],
    targets: [
        .target(name: "Shared", dependencies: ["Core"]),
        .target(name: "EnterName", dependencies: ["Core", "Shared"]),
        .target(name: "Paywall", dependencies: ["Core", "Shared"]),
        .testTarget(name: "ShellTests", dependencies: ["Shared"])
    ]
)

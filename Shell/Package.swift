// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Shell",
    platforms: [ .iOS(.v13), .macOS(.v11) ],
    products: [
        .library(name: "Shared", targets: ["Shared"]),
        .library(name: "EnterName", targets: ["EnterName"])
    ],
    dependencies: [
        .package(path: "Core"),
        .package(name: "ReduxStore", path: "../Store")
    ],
    targets: [
        .target(name: "Shared", dependencies: ["Core", "ReduxStore"]),
        .target(name: "EnterName", dependencies: ["Core", "ReduxStore", "Shared"]),
        .testTarget(name: "ShellTests", dependencies: ["Shared"])
    ]
)

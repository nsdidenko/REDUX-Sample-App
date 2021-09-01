// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Shell",
    platforms: [ .iOS(.v13), .macOS(.v11) ],
    products: [
        .library(name: "Shell", targets: ["Shell"]),
    ],
    dependencies: [
        .package(path: "Core"),
        .package(name: "ReduxStore", path: "../Store")
    ],
    targets: [
        .target(name: "Shell", dependencies: ["Core", "ReduxStore"]),
        .testTarget(name: "ShellTests", dependencies: ["Shell"])
    ]
)

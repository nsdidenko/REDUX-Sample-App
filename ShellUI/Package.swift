// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "ShellUI",
    platforms: [ .iOS(.v13) ],
    products: [ .library(name: "ShellUI", targets: ["ShellUI"]) ],
    dependencies: [
        .package(path: "Shell"),
        .package(name: "ReduxStore", path: "../Store"),
    ],
    targets: [
        .target(name: "ShellUI", dependencies: ["Shell", "ReduxStore"], path: "Sources"),
        .testTarget(name: "ShellUITests", dependencies: ["ShellUI"], path: "Tests")
    ]
)

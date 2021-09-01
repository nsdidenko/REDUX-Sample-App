// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Shell",
    platforms: [ .iOS(.v13) ],
    products: [
        .library(name: "Shell", targets: ["Shell"]),
    ],
    targets: [
        .target(name: "Shell"),
        .testTarget(name: "ShellTests", dependencies: ["Shell"])
    ]
)

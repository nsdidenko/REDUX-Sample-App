// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [ .iOS(.v13), .macOS(.v10_15) ],
    products: [ .library(name: "Core", targets: ["Core"]) ],
    targets: [
        .target(name: "Core", path: "Sources"),
        .testTarget(name: "CoreTests", dependencies: ["Core"], path: "Tests")
    ]
)

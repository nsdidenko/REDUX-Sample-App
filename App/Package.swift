// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "App",
    platforms: [ .iOS(.v14) ],
    products: [
        .library(name: "Core", targets: ["Core"]),
        .library(name: "UI", targets: ["UI"]),
    ],
    dependencies: [
        .package(path: "Foundation")
    ],
    targets: [
        .target(name: "Core", dependencies: []),
        .target(name: "UI", dependencies: [
            "Core",
            .product(name: "Injected", package: "Foundation"),
            .product(name: "Command", package: "Foundation"),
            .product(name: "Helpers", package: "Foundation"),
            .product(name: "ReduxStore", package: "Foundation")
        ])
    ]
)

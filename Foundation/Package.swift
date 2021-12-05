// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Foundation",
    platforms: [ .iOS(.v14) ],
    products: [
        .library(name: "Injected", targets: ["Injected"]),
        .library(name: "Command", targets: ["Command"]),
        .library(name: "Helpers", targets: ["Helpers"]),
        .library(name: "ReduxStore", targets: ["ReduxStore"])
    ],
    targets: [
        .target(name: "Injected"),
        .target(name: "Command"),
        .target(name: "Helpers"),
        .target(name: "ReduxStore")
    ]
)

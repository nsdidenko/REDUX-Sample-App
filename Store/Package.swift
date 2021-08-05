// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "ReduxStore",
    products: [
        .library(name: "ReduxStore", targets: ["ReduxStore"]),
    ],
    targets: [
        .target( name: "ReduxStore", path: "Sources"),
        .testTarget(name: "ReduxStoreTests", dependencies: ["ReduxStore"], path: "Tests")
    ]
)

// swift-tools-version:5.5

import PackageDescription

private let core = module(named: .Core)
private let ui = module(named: .UI, dependencies: [.Core])

let package = Package(
    name: "App",
    platforms: [
        .iOS(.v14)
    ],
    modules: [
        core, ui
    ])

// MARK: - Helpers

private enum ModuleName: String {
    case Core, UI
}

private struct Module {
    let lib: Product
    let target: Target
}

private func module(named name: ModuleName, dependencies: [ModuleName] = []) -> Module {
    .init(
        lib: .library(name: name.rawValue, targets: [name.rawValue]),
        target: .target(name: name.rawValue, dependencies: dependencies.map { .init(stringLiteral: "\($0.rawValue)") }))
}

private extension Package {
    convenience init(name: String, platforms: [SupportedPlatform], modules: [Module]) {
        self.init(name: name, platforms: platforms, products: modules.map(\.lib), targets: modules.map(\.target))
    }
}

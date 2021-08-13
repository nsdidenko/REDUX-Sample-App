
public protocol Action {}

// MARK: - Конкретные экшены

public struct Initial: Action & Equatable { public init() {} }

public struct SkipOnboarding: Action & Equatable {
    public let flag: Bool

    public init(flag: Bool) {
        self.flag = flag
    }
}

public struct DidFinishLaunch: Action & Equatable { public init() {} }

public struct DidLoadRemoteConfig: Action & Equatable { public init() {} }

public struct DidEditName: Action & Equatable {
    public let value: String

    public init(with value: String) {
        self.value = value
    }
}

public struct DidEnterName: Action & Equatable {
    public let name: Name

    public init(_ name: Name) {
        self.name = name
    }
}

public struct DidPurchase: Action & Equatable { public init() {} }

// MARK: - SomeAction в боевом проекте кодогенерируется

public enum SomeAction {
    case initial(Initial)
    case didEditName(DidEditName)
    case didEnterName(DidEnterName)
    case skipOnboarding(SkipOnboarding)
    case didFinishLaunch(DidFinishLaunch)
    case didLoadRemoteConfig(DidLoadRemoteConfig)
    case didPurchase(DidPurchase)

    init<A>(action: A) {
        switch action {
        case let action as Initial:
            self = .initial(action)

        case let action as SkipOnboarding:
            self = .skipOnboarding(action)

        case let action as DidFinishLaunch:
            self = .didFinishLaunch(action)

        case let action as DidEditName:
            self = .didEditName(action)

        case let action as DidEnterName:
            self = .didEnterName(action)

        case let action as DidLoadRemoteConfig:
            self = .didLoadRemoteConfig(action)

        case let action as DidPurchase:
            self = .didPurchase(action)

        default:
            fatalError("Unknown action: \(action)")
        }
    }

    public var action: Action {
        switch self {
        case let .initial(action): return action
        case let .skipOnboarding(action): return action
        case let .didEditName(action): return action
        case let .didEnterName(action): return action
        case let .didFinishLaunch(action): return action
        case let .didLoadRemoteConfig(action): return action
        case let .didPurchase(action): return action
        }
    }
}

extension SomeAction: Equatable {}


public protocol Action {}

// MARK: - Конкретные экшены

public struct Initial: Action { public init() {} }

public struct SkipOnboarding: Action {
    public let flag: Bool

    public init(flag: Bool) {
        self.flag = flag
    }
}

public struct DidFinishLaunch: Action { public init() {} }

public struct DidLoadRemoteConfig: Action { public init() {} }

public struct DidEnterName: Action {
    public let name: String

    public init(_ name: String) {
        self.name = name
    }
}

// MARK: - SomeAction в боевом проекте кодогенерируется

public enum SomeAction {
    case initial(Initial)
    case didEnterName(DidEnterName)
    case skipOnboarding(SkipOnboarding)
    case didFinishLaunch(DidFinishLaunch)
    case didLoadRemoteConfig(DidLoadRemoteConfig)

    init<A>(action: A) {
        switch action {
        case let action as Initial:
            self = .initial(action)

        case let action as SkipOnboarding:
            self = .skipOnboarding(action)

        case let action as DidFinishLaunch:
            self = .didFinishLaunch(action)

        case let action as DidEnterName:
            self = .didEnterName(action)

        case let action as DidLoadRemoteConfig:
            self = .didLoadRemoteConfig(action)

        default:
            fatalError("Unknown action: \(action)")
        }
    }

    public var action: Action {
        switch self {
        case let .initial(action): return action
        case let .skipOnboarding(action): return action
        case let .didEnterName(action): return action
        case let .didFinishLaunch(action): return action
        case let .didLoadRemoteConfig(action): return action
        }
    }
}

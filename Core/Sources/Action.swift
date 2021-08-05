
public protocol Action {}

// MARK: - Конкретные экшены

public struct Initial: Action { public init() {} }

public struct DidFinishLaunch: Action { public init() {} }

public struct DidLoadRemoteConfig: Action { public init() {} }

public struct StartOnboarding: Action { public init() {} }

public struct StartHome: Action { public init() {} }

public struct SetUserName: Action {
    public let name: String

    public init(name: String) {
        self.name = name
    }
}

// MARK: - SomeAction в боевом проекте кодогенерируется

public enum SomeAction {
    case initial(Initial)
    case setUserName(SetUserName)
    case didFinishLaunch(DidFinishLaunch)
    case didLoadRemoteConfig(DidLoadRemoteConfig)
    case startOnboarding(StartOnboarding)
    case startHome(StartHome)

    init<A>(action: A) {
        switch action {
        case let action as Initial:
            self = .initial(action)

        case let action as DidFinishLaunch:
            self = .didFinishLaunch(action)

        case let action as SetUserName:
            self = .setUserName(action)

        case let action as DidLoadRemoteConfig:
            self = .didLoadRemoteConfig(action)

        case let action as StartOnboarding:
            self = .startOnboarding(action)

        case let action as StartHome:
            self = .startHome(action)

        default:
            fatalError("Unknown action: \(action)")
        }
    }

    public var action: Action {
        switch self {
        case let .initial(action): return action
        case let .setUserName(action): return action
        case let .didFinishLaunch(action): return action
        case let .didLoadRemoteConfig(action): return action
        case let .startOnboarding(action): return action
        case let .startHome(action): return action
        }
    }
}

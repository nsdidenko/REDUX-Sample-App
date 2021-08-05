
public protocol Action {}

public struct Initial: Action { public init() {} }

public struct DidFinishLaunch: Action { public init() {} }

public struct SetUserName: Action {
    public let name: String

    public init(name: String) {
        self.name = name
    }
}

// MARK: - Helper

public enum SomeAction {
    case initial(Initial)
    case setUserName(SetUserName)
    case didFinishLaunch(DidFinishLaunch)

    init<A>(action: A) {
        switch action {
        case let action as Initial:
            self = .initial(action)

        case let action as DidFinishLaunch:
            self = .didFinishLaunch(action)

        case let action as SetUserName:
            self = .setUserName(action)

        default:
            fatalError("Unknown action: \(action)")
        }
    }
}
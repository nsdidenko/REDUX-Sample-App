
protocol Action {}

struct Initial: Action {}

struct DidFinishLaunch: Action {}

struct SetUserName: Action {
    let name: String
}

// MARK: - Helper

enum SomeAction {
    case initial(Initial)
    case setUserName(SetUserName)

    init<A>(action: A) {
        switch action {
        case let action as Initial:
            self = .initial(action)
        case let action as SetUserName:
            self = .setUserName(action)
        default:
            fatalError("Unknown action: \(action)")
        }
    }
}



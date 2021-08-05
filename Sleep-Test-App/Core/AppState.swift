
struct AppState {
    var user: User = User()
    var lastSomeAction: SomeAction = .initial(Initial())

    mutating func reduce(_ action: Action) {
        user.reduce(action)
    }
}

struct User {
    var name: String = ""

    mutating func reduce(_ action: Action) {
        switch action {
        case let action as SetUserName:
            name = action.name

        default:
            break
        }
    }
}

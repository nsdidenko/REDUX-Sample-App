
public struct AppState {
    public private(set) var user: User
    public private(set) var lastSomeAction: SomeAction

    public init(
        user: User = .init(),
        lastSomeAction: SomeAction = .initial(Initial())
    ) {
        self.user = user
        self.lastSomeAction = lastSomeAction
    }

    public mutating func reduce(_ action: Action) {
        user.reduce(action)
        lastSomeAction = SomeAction(action: action)
    }

}

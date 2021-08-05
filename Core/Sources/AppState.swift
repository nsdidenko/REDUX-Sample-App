
public struct AppState {
    public private(set) var flow: Flow
    public private(set) var user: User
    public private(set) var lastSomeAction: SomeAction

    public init(
        flow: Flow = .init(),
        user: User = .init(),
        lastSomeAction: SomeAction = .initial(Initial())
    ) {
        self.flow = flow
        self.user = user
        self.lastSomeAction = lastSomeAction
    }

    public mutating func reduce(_ action: Action) {
        flow.reduce(action)
        user.reduce(action)
        lastSomeAction = SomeAction(action: action)
    }
}

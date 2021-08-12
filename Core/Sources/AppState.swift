
public struct AppState {
    public private(set) var flow: Flow
    public private(set) var user: User
    public private(set) var nameInput: NameInput
    public private(set) var lastSomeAction: SomeAction

    public init(
        flow: Flow = .init(),
        user: User = .init(),
        nameInput: NameInput = .init(),
        lastSomeAction: SomeAction = .initial(Initial())
    ) {
        self.flow = flow
        self.user = user
        self.nameInput = nameInput
        self.lastSomeAction = lastSomeAction
    }

    public mutating func reduce(_ action: Action) {
        flow.reduce(action)
        user.reduce(action)
        nameInput.reduce(action)
        lastSomeAction = SomeAction(action: action)
    }
}

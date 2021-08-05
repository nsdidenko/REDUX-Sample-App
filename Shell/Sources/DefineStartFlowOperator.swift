import Core
import ReduxStore

public struct DefineStartFlowOperator {
    private let store: Store<AppState, Action>

    init(store: Store<AppState, Action>) {
        self.store = store
    }

    public func process(_ state: AppState) {
        guard state.lastSomeAction.action is DidLoadRemoteConfig else { return }

        // Это должно взяться из UserDefaults (например)
        let needToShowOnboarding = Bool.random()

        let action: Action = needToShowOnboarding
            ? StartOnboarding()
            : StartHome()

        store.dispatch(action: action)
    }
}

public extension Store where State == Core.AppState, Action == Core.Action {
    func subscribeDefineStartFlowOperator() {
        let op = DefineStartFlowOperator(store: self)
        subscribe(observer: .init(action: op.process).dispatched(on: .main))
    }
}

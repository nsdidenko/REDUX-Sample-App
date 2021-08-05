import Core
import ReduxStore
import Foundation

public class FirebaseOperator {
    public let store: Store<AppState, Action>
    private var currentFlow: Flow?

    public init(store: Store<AppState, Action>) {
        self.store = store
    }

    public func process(_ state: AppState) {
        guard state.flow == .splash, state.flow != currentFlow else { return }
        currentFlow = state.flow
        
        // Simulate request
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            self.store.dispatch(action: DidLoadRemoteConfig())
        }
    }
}

public extension Store where State == Core.AppState, Action == Core.Action {
    func subscribeFirebaseOperator() {
        let op = FirebaseOperator(store: self)
        subscribe(observer: .init(action: op.process).dispatched(on: .main))
    }
}

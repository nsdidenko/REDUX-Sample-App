import Core
import ReduxStore
import Foundation

public class FirebaseOperator {
    public let store: Store<AppState, Action>

    private var currentCheckPoint: Flow.CheckPoint?

    public init(store: Store<AppState, Action>) {
        self.store = store
    }

    public func process(_ state: Flow.CheckPoint) {
        guard state == .splash, state != currentCheckPoint else { return }
        currentCheckPoint = state
        
        // Simulate request
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            self.store.dispatch(action: DidLoadRemoteConfig())
        }
    }
}

public extension Store where State == Core.AppState, Action == Core.Action {
    func subscribeFirebaseOperator() {
        let op = FirebaseOperator(store: self)
        subscribe(observer: .init { op.process($0.flow.currentCheckPoint) }.dispatched(on: .main) )
    }
}

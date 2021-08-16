import Core
import ReduxStore
import Foundation

public typealias Fetch = (@escaping () -> ()) -> Void

public class FirebaseOperator {
    public let store: Store<AppState, Action>
    public let fetch: Fetch

    public init(store: Store<AppState, Action>, fetch: @escaping Fetch) {
        self.store = store
        self.fetch = fetch
    }

    private var currentCheckPoint: Flow.CheckPoint?

    public func process(_ state: Flow.CheckPoint) {
        guard state == .splash, state != currentCheckPoint else { return }
        currentCheckPoint = state

        fetch() {
            self.store.dispatch(action: DidLoadRemoteConfig())
        }
    }
}

public extension Store where State == Core.AppState, Action == Core.Action {
    func subscribeFirebaseOperator(fetch: @escaping Fetch) {
        let op = FirebaseOperator(store: self, fetch: fetch)
        subscribe(observer: .init { op.process($0.flow.currentCheckPoint) }.dispatched(on: .main) )
    }
}

public enum FirebaseRemoteConfigFetch {
    public static func run(completion: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: completion)
    }
}

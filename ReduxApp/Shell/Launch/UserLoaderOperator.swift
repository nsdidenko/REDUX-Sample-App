import Foundation

public final class UserLoaderOperator {
    public typealias Store = ReduxApp.Store<AppState, Action>
    public typealias Observer = ReduxApp.Observer<AppState>

    private let store: Store
    private let defaults: UserDefaults

    public init(store: Store, defaults: UserDefaults = .standard) {
        self.store = store
        self.defaults = defaults
    }

    private var status: User.Status?

    public func process(_ state: User) -> Observer.Status {
        guard status != state.status else { return .active }
        status = state.status

        if status == .loading {
            if let name = defaults.string(forKey: "user_name") {
                store.dispatch(action: DidLoadName(name))
            }
            return .dead
        } else {
            return .active
        }
    }

    public var asObserver: Observer {
        .init { self.process($0.user) }
    }
}

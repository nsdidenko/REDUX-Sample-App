import Foundation

public final class UserDefaultsNameCacheOperator {
    public typealias Store = ReduxApp.Store<AppState, Action>
    public typealias Observer = ReduxApp.Observer<AppState>

    private let store: Store
    private let defaults: UserDefaults

    public init(store: Store, defaults: UserDefaults = .standard) {
        self.store = store
        self.defaults = defaults
    }

    private var name: String?

    public func process(_ state: User) {
        guard name != state.name else { return }
        name = state.name

        if let name = name, !name.isEmpty {
            defaults.setValue(name, forKey: "user_name")
        } else {
            defaults.removeObject(forKey: "user_name")
        }
    }

    public var asObserver: Observer {
        .init {
            self.process($0.user)
            return .active
        }
    }
}

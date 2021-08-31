import Foundation

public final class UserNameCacheOperator {
    public typealias Store = ReduxApp.Store<AppState, Action>
    public typealias Observer = ReduxApp.Observer<AppState>
    public typealias Cache = (String) -> Void
    public typealias Remove = () -> Void

    private let store: Store
    private let cache: Cache
    private let remove: Remove

    public init(store: Store, cache: @escaping Cache, remove: @escaping Remove) {
        self.store = store
        self.cache = cache
        self.remove = remove
    }

    private var name: String?

    public var asObserver: Observer {
        .init {
            self.process($0.user)
            return .active
        }
    }

    private func process(_ state: User) {
        guard name != state.name else { return }
        name = state.name

        name.map { $0.isEmpty ? remove() : cache($0) }
    }
}

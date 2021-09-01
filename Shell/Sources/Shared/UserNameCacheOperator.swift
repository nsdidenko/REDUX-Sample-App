import Foundation
import Core

public final class UserNameCacheOperator {
    public typealias Cache = (String) -> Void
    public typealias Remove = () -> Void

    private let store: Store
    private let cache: Cache
    private let remove: Remove

    private var name: String

    public init(store: Store, cache: @escaping Cache, remove: @escaping Remove) {
        self.store = store
        self.cache = cache
        self.remove = remove

        name = store.state.user.name
    }

    public var asObserver: Observer {
        .init {
            self.process($0.user)
            return .active
        }
    }

    private func process(_ state: User) {
        guard name != state.name else { return }
        name = state.name

        name.isEmpty ? remove() : cache(name)
    }
}

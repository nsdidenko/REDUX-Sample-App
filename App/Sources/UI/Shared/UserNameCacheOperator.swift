import Foundation
import Core
import Helpers

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

    public func process(_ state: AppState) {
        let name = state.user.name
        
        guard self.name != name else { return }
        self.name = name

        name.isEmpty ? remove() : cache(name)
    }
}

import Foundation
import Core

public final class UserNameLoadOperator {
    public typealias Load = (@escaping (String) -> Void) -> Void

    private let store: Store
    public let load: Load

    public init(store: Store, load: @escaping Load) {
        self.store = store
        self.load = load
    }

    private var needToProcess = true

    public var asObserver: Observer {
        .init {
            self.process($0.user)
            return .dead
        }
    }

    private func process(_ state: User) {
        guard needToProcess else { return }
        needToProcess = false

        load() { [weak store] name in
            store?.dispatch(action: DidLoadName(name))
        }
    }
}
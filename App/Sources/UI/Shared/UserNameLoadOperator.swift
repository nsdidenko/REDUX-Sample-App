import Foundation
import Core
import Helpers

public final class UserNameLoadOperator {
    public typealias Load = (@escaping (String) -> Void) -> Void

    private let store: Store
    public let load: Load

    public init(store: Store, load: @escaping Load) {
        self.store = store
        self.load = load
    }

    private var needToProcess = true

    public func process(_ state: AppState) {
        guard needToProcess else { return }
        needToProcess = false

        load() { [weak store] name in
            store?.dispatch(DidLoadName(name))
        }
    }
}

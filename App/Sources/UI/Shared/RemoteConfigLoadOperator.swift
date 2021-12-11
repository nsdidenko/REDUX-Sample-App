import Foundation
import Core
import Helpers

public final class RemoteConfigLoadOperator {
    public typealias Load = (@escaping (RemoteConfig) -> Void) -> Void

    public let store: Store
    public let load: Load

    private var needToProcess = true

    public init(store: Store, fetch: @escaping Load) {
        self.store = store
        self.load = fetch
    }

    public func process(_ state: AppState) {
        guard needToProcess else { return }
        needToProcess = false

        load() {
            self.store.dispatch(DidLoadRemoteConfig(remoteConfig: $0))
        }
    }
}

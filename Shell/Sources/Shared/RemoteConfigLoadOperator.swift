import Foundation
import Core

public final class RemoteConfigLoadOperator {
    public typealias Load = (@escaping (RemoteConfig) -> Void) -> Void

    public let store: Store
    public let load: Load

    private var needToProcess = true

    public init(store: Store, fetch: @escaping Load) {
        self.store = store
        self.load = fetch
    }

    public var asObserver: Observer {
        .init(ids: []) {
            self.process($0)
            return .dead
        }
    }

    private func process(_ state: AppState) {
        guard needToProcess else { return }
        needToProcess = false

        load() {
            self.store.dispatch(action: DidLoadRemoteConfig(remoteConfig: $0))
        }
    }
}

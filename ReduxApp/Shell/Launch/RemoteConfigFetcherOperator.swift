import Foundation

public final class RemoteConfigFetcherOperator {
    public typealias Store = ReduxApp.Store<AppState, Action>
    public typealias Observer = ReduxApp.Observer<AppState>
    public typealias Fetch = (@escaping () -> Void) -> Void

    public let store: Store
    public let fetch: Fetch

    public init(store: Store, fetch: @escaping Fetch) {
        self.store = store
        self.fetch = fetch
    }

    private var status: RemoteConfig.Status?

    public func process(_ state: RemoteConfig) -> Observer.Status {
        guard state.status != status else { return .active }
        status = state.status

        if status == .loading {
            fetch() {
                self.store.dispatch(action: DidLoadRemoteConfig())
            }
            return .dead
        } else {
            return .active
        }
    }

    public var asObserver: Observer {
        .init { self.process($0.remoteConfig) }
    }
}

public enum RemoteConfigFetch {
    public static func run(completion: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: completion)
    }
}

import Foundation

public final class PaywallsLoadOperator {
    public typealias Store = ReduxApp.Store
    public typealias Observer = ReduxApp.Observer
    public typealias Load = (@escaping ([Paywall]) -> Void) -> Void

    private let store: Store
    private let load: Load

    public init(store: Store, load: @escaping Load) {
        self.store = store
        self.load = load
    }

    private var status: PaywallsLoadingStatus?

    public var asObserver: Observer {
        .init { self.process($0.paywallsLoadingStatus) }
    }

    private func process(_ state: PaywallsLoadingStatus) -> Observer.Status {
        guard status != state else { return .active }
        status = state

        if status == .loading {
            load() { [weak store] paywalls in
                store?.dispatch(action: DidLoadPaywalls(paywalls: paywalls))
            }
            return .dead
        } else {
            return .active
        }
    }
}

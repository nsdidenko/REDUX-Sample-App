import Foundation
import Core
import Helpers

public final class PaywallsLoadOperator {
    public typealias Load = (@escaping ([Paywall]) -> Void) -> Void

    private let store: Store
    private let load: Load

    public init(store: Store, load: @escaping Load) {
        self.store = store
        self.load = load
    }

    private var status: PaywallsLoadingStatus?

    public var asObserver: Observer {
        .init(id: typename(self), ids: PaywallsLoadingStatus.id) {
            self.process($0)
        }
    }

    private func process(_ state: AppState) -> Observer.Status {
        let status = state.paywallsLoadingStatus
        
        guard self.status != status else { return .active }
        self.status = status

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

import UIKit
import Core
import Helpers

public final class PaywallShowOperator {
    private let store: Store
    private let navigationController: UINavigationController

    public init(store: Store, navigationController: UINavigationController) {
        self.store = store
        self.navigationController = navigationController
    }

    private var isEnterNameCompleted = false

    public var asObserver: Observer {
        .init(id: typename(self), ids: Flow.id) {
            self.process($0)
        }
    }

    private func process(_ state: AppState) -> Observer.Status {
        let isEnterNameCompleted = state.flow.isEnterNameCompleted
        
        guard self.isEnterNameCompleted != isEnterNameCompleted else { return .active }
        self.isEnterNameCompleted = isEnterNameCompleted

        if isEnterNameCompleted {
            let vc = PaywallUIComposer.compose(store: store)
            navigationController.pushViewController(vc, animated: true)
        }

        return .active
    }
}

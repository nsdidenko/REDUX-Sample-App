import UIKit

public final class PaywallShowOperator {
    public typealias Store = ReduxApp.Store<AppState, Action>
    public typealias Observer = ReduxApp.Observer<AppState>

    private let store: Store
    private let navigationController: UINavigationController

    public init(store: Store, navigationController: UINavigationController) {
        self.store = store
        self.navigationController = navigationController
    }

    private var isEnterNameCompleted = false

    public var asObserver: Observer {
        .init { self.process($0.flow) }
    }

    private func process(_ state: Flow) -> Observer.Status {
        guard state.isEnterNameCompleted != isEnterNameCompleted else { return .active }
        isEnterNameCompleted = state.isEnterNameCompleted

        if isEnterNameCompleted {
            let vc = PaywallUIComposer.compose(store: store)
            navigationController.pushViewController(vc, animated: true)
        }

        return .active
    }
}

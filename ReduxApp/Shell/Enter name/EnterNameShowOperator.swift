import UIKit

public final class EnterNameShowOperator {
    public typealias Store = ReduxApp.Store
    public typealias Observer = ReduxApp.Observer

    private let store: Store
    private let navigationController: UINavigationController

    public init(store: Store, navigationController: UINavigationController) {
        self.store = store
        self.navigationController = navigationController
    }

    private var isSplashCompleted = false

    public var asObserver: Observer {
        .init { self.process($0.flow) }
    }

    private func process(_ state: Flow) -> Observer.Status {
        guard state.isSplashCompleted != isSplashCompleted else { return .active }
        isSplashCompleted = state.isSplashCompleted

        if isSplashCompleted, let window = UIApplication.shared.windows.first {
            let vc = EnterNameUIComposer.compose(store: store)
            navigationController.setViewControllers([vc], animated: true)
            window.rootViewController = navigationController
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
            return .dead
        } else {
            return .active
        }
    }
}

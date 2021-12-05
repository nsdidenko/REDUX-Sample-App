import UIKit
import Core
import Helpers

public final class EnterNameShowOperator {
    private let store: Store
    private let navigationController: UINavigationController

    public init(store: Store, navigationController: UINavigationController) {
        self.store = store
        self.navigationController = navigationController
    }

    private var isSplashCompleted = false

    public var asObserver: Observer {
        .init(id: typename(self), ids: Flow.id) {
            self.process($0)
        }
    }

    private func process(_ state: AppState) -> Observer.Status {
        let isSplashCompleted = state.flow.isSplashCompleted
        
        guard self.isSplashCompleted != isSplashCompleted else { return .active }
        self.isSplashCompleted = isSplashCompleted

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

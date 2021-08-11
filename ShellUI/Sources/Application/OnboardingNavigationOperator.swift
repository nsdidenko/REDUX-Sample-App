import UIKit
import Core
import ReduxStore

public class OnboardingNavigationOperator {
    private let navigationController: UINavigationController
    private let vc: () -> UIViewController

    init(navigationController: UINavigationController, vc: @escaping () -> UIViewController) {
        self.navigationController = navigationController
        self.vc = vc
    }

    private var currentName: User.Name?

    public func process(_ state: User) {
        guard currentName != state.name else { return }
        currentName = state.name

        navigationController.pushViewController(vc(), animated: true)
    }
}

public extension Store where State == Core.AppState, Action == Core.Action {
    func subscribeOnboardingNavigationOperator(nc: UINavigationController) {
        let op = OnboardingNavigationOperator(
            navigationController: nc,
            vc: { PaywallUIComposer.compose(store: self) })

        subscribe(observer: .init { op.process($0.user) }.dispatched(on: .main))
    }
}

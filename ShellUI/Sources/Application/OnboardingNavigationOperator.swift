import UIKit
import Core
import ReduxStore

public class OnboardingNavigationOperator {
    private let navigationController: UINavigationController
    private let nextVC: () -> UIViewController

    public init(navigationController: UINavigationController, nextVC: @escaping () -> UIViewController) {
        self.navigationController = navigationController
        self.nextVC = nextVC
    }

    private var currentName: Name?

    public func process(_ state: User) {
        guard currentName != state.name, !state.name.value.isEmpty else { return }
        currentName = state.name

        navigationController.pushViewController(nextVC(), animated: true)
    }
}

public extension Store where State == Core.AppState, Action == Core.Action {
    func subscribeOnboardingNavigationOperator(nc: UINavigationController, nextVC: @escaping () -> UIViewController) {
        let op = OnboardingNavigationOperator(
            navigationController: nc,
            nextVC: { PaywallUIComposer.compose(store: self) })

        subscribe(observer: .init { op.process($0.user) }.dispatched(on: .main))
    }
}

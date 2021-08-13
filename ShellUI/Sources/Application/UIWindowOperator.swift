import UIKit
import Core
import ReduxStore

public class UIWindowOperator: Storyboarded {
    private let window: () -> UIWindow
    private let root: (Flow.CheckPoint) -> UIViewController?

    public init(window: @escaping () -> UIWindow,
         root: @escaping (Flow.CheckPoint) -> UIViewController?
    ) {
        self.window = window
        self.root = root
    }

    private var currentCheckPoint: Flow.CheckPoint?

    public func process(_ state: Flow.CheckPoint) {
        guard currentCheckPoint != state else { return }
        currentCheckPoint = state

        if let vc = root(state) {
            let window = window()
            window.rootViewController = vc
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        }
    }
}

public extension Store where State == Core.AppState, Action == Core.Action {
    func subscribeUIWindowOperator(window: @escaping () -> UIWindow, nc: UINavigationController) {
        let op = UIWindowOperator(window: window) { $0.toVC(store: self, nc: nc) }
        subscribe(observer: .init(action: { op.process($0.flow.currentCheckPoint) }).dispatched(on: .main))
    }
}

private extension Flow.CheckPoint {
    func toVC(store: Store<AppState, Action>, nc: UINavigationController) -> UIViewController? {
        switch self {
        case .onboarding:
            nc.setViewControllers([EnterNameUIComposer.compose(store: store)], animated: true)
            return nc

        case .home:
            return HomeUIComposer.compose(store: store)

        default:
            return nil
        }
    }
}

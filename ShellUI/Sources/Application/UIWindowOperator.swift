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
        let mapper = CheckPointToVCMapper(store: self, nc: nc)
        let op = UIWindowOperator(window: window) { mapper.map($0) }
        subscribe(observer: .init(action: { op.process($0.flow.currentCheckPoint) }).dispatched(on: .main))
    }
}

public struct CheckPointToVCMapper {
    private let store: Store<AppState, Action>
    private let nc: UINavigationController

    public init(store: Store<AppState, Action>, nc: UINavigationController) {
        self.store = store
        self.nc = nc
    }

    public func map(_ checkPoint: Flow.CheckPoint) -> UIViewController? {
        switch checkPoint {
        case .onboarding:
            nc.setViewControllers([EnterNameUIComposer.compose(store: store)], animated: true)
            return nc

        case .home:
            nc.setViewControllers([HomeViewController()], animated: false)
            return nc

        default:
            return nil
        }
    }
}

import UIKit
import Core
import ReduxStore

public class UIFlowOperator {
    private let store: Store<AppState, Action>
    private var window: () -> UIWindow

    private var currentCheckPoint: Flow.CheckPoint?

    public init(store: Store<AppState, Action>, window: @escaping () -> UIWindow) {
        self.store = store
        self.window = window
    }

    public func process(_ state: AppState) {
        processOnboardingIfNeeded(state.flow.currentCheckPoint)
        processHomeIfNeeded(state.flow.currentCheckPoint)
    }

    // MARK: - Private

    private func processOnboardingIfNeeded(_ checkPoint: Flow.CheckPoint) {
        guard checkPoint == .onboarding, checkPoint != currentCheckPoint else { return }
        currentCheckPoint = checkPoint

        setRoot(withStoryboardName: "Onboarding", id: "EnterNameViewController")
    }

    private func processHomeIfNeeded(_ checkPoint: Flow.CheckPoint) {
        guard checkPoint == .home, checkPoint != currentCheckPoint else { return }
        currentCheckPoint = checkPoint

        setRoot(withStoryboardName: "Home", id: "HomeViewController")
    }

    // MARK: - Helpers

    private func setRoot(withStoryboardName name: String, id: String) {
        let sb = UIStoryboard.init(name: name, bundle: Bundle.module)
        let vc = sb.instantiateViewController(identifier: id)
        let window = window()
        window.rootViewController = vc
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }
}

public extension Store where State == Core.AppState, Action == Core.Action {
    func subscribeUIFlowOperator(window: @escaping () -> UIWindow) {
        let op = UIFlowOperator(store: self, window: window)
        subscribe(observer: .init(action: op.process).dispatched(on: .main))
    }
}

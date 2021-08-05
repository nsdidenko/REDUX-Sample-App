import UIKit
import Core
import ReduxStore

public class UIFlowOperator {
    private let store: Store<AppState, Action>
    private var window: UIWindow?

    private var currentFlow: Flow?

    public init(store: Store<AppState, Action>) {
        self.store = store
    }

    public func process(_ state: AppState) {
        processSplashIfNeeded(state.flow)
        processOnboardingIfNeeded(state.flow)
        processHomeIfNeeded(state.flow)
    }

    // MARK: - Private

    private func processSplashIfNeeded(_ flow: Flow) {
        guard flow == .splash, flow != currentFlow else { return }
        currentFlow = flow

        window = UIApplication.shared.windows.first

        setRoot(withStoryboardName: "Splash", id: "SplashViewController")
    }

    private func processOnboardingIfNeeded(_ flow: Flow) {
        guard flow == .onboarding, flow != currentFlow else { return }
        currentFlow = flow

        setRoot(withStoryboardName: "Onboarding", id: "WelcomeViewController")
    }

    private func processHomeIfNeeded(_ flow: Flow) {
        guard flow == .home, flow != currentFlow else { return }
        currentFlow = flow

        setRoot(withStoryboardName: "Home", id: "HomeViewController")
    }

    // MARK: - Helpers

    private func setRoot(withStoryboardName name: String, id: String) {
        let sb = UIStoryboard.init(name: name, bundle: Bundle.module)
        let vc = sb.instantiateViewController(identifier: id)
        if let window = window {
            window.rootViewController = vc
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        }
    }
}

public extension Store where State == Core.AppState, Action == Core.Action {
    func subscribeUIFlowOperator() {
        let op = UIFlowOperator(store: self)
        subscribe(observer: .init(action: op.process).dispatched(on: .main))
    }
}

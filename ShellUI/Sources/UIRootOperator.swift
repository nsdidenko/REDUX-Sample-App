import UIKit
import Core
import ReduxStore

public class UIRootOperator {
    private let store: Store<AppState, Action>
    private var window: UIWindow?

    public init(store: Store<AppState, Action>) {
        self.store = store
    }

    public func process(_ state: AppState) {
        guard state.lastSomeAction.action is DidFinishLaunch else { return }

        let sb = UIStoryboard.init(name: "Main", bundle: Bundle.module)
        let vc = sb.instantiateInitialViewController()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}

public extension Store where State == Core.AppState, Action == Core.Action {
    func subscribeUIRootOperator() {
        let op = UIRootOperator(store: self)
        subscribe(observer: .init(action: op.process).dispatched(on: .main))
    }
}

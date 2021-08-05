import UIKit
import Core
import ReduxStore
import Shell
import ShellUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let store: Store<AppState, Action>

    override init() {
        store = Store(initial: .init()) { $0.reduce($1) }
        super.init()

        store.subscribeUIRootOperator()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        store.dispatch(action: DidFinishLaunch())
        return true
    }
}

public struct InfrastructureInitOperator {
    public let store: Store<AppState, Action>

    public init(store: Store<AppState, Action>) {
        self.store = store
    }

    public func process(_ state: AppState) {
        
    }
}

import UIKit
import Core
import ReduxStore
import Shell
import ShellUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate, Storyboarded {
    var window: UIWindow?

    private let store: Store<AppState, Action>

    override init() {
        store = Store(initial: .init()) { $0.reduce($1) }

        super.init()

        store.subscribeFlowLoadOperator(skipOnboarding: { false })
        store.subscribeUIWindowOperator(window: { [unowned self] in self.window! })
        store.subscribeFirebaseOperator()
        store.subscribeLastActionConsolePrintOperator()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        splash()

        store.dispatch(action: DidFinishLaunch())
        return true
    }

    private func splash() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        let vc = storyboarded(.splash, ofType: SplashViewController.self)
        window?.rootViewController = vc
    }
}

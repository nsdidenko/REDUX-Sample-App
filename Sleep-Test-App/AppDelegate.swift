import UIKit
import Core
import ReduxStore
import Shell
import ShellUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private let store: Store<AppState, Action>
    private var navigationController = UINavigationController()

    override init() {
        store = Store(initial: .init()) { $0.reduce($1) }

        super.init()

        store.subscribeFlowLoadOperator(skipOnboarding: { false })
        store.subscribeUIWindowOperator(window: { [unowned self] in self.window! }, nc: navigationController)
        store.subscribeOnboardingNavigationOperator(nc: navigationController, nextVC: { [unowned self] in PaywallUIComposer.compose(store: self.store) })
        store.subscribeFirebaseOperator(fetch: FirebaseRemoteConfigFetch.run)
        store.subscribeLastActionConsolePrintOperator()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = SplashViewController()

        store.dispatch(action: DidFinishLaunch())
        return true
    }
}

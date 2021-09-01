import UIKit
import Core
import EnterName
import Shared
import Paywall

@main
class AppDelegate: UIResponder {
    var window: UIWindow?

    private let store: Store
    private let navigationController = UINavigationController()

    override init() {
        store = Store(initial: .init()) {
            print("Action -> \($1)")
            $0.reduce($1)
        }

        super.init()
        setupOperators()
    }
}

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        store.dispatch(action: DidFinishLaunch())
        return true
    }
}

// MARK: - Private

private extension AppDelegate {
    func setupOperators() {
        let splashShowOperator = SplashShowOperator(window: window, splash: { SplashViewController() })
        store.subscribe(observer: splashShowOperator.asObserver)

        let remoteConfigLoadOperator = RemoteConfigLoadOperator(store: store, fetch: RemoteConfigLoader.load)
        store.subscribe(observer: remoteConfigLoadOperator.asObserver)

        let enterNameShowOperator = EnterNameShowOperator(store: store, navigationController: navigationController)
        store.subscribe(observer: enterNameShowOperator.asObserver)

        let paywallShowOperator = PaywallShowOperator(store: store, navigationController: navigationController)
        store.subscribe(observer: paywallShowOperator.asObserver)

        let paywallsLoadOperator = PaywallsLoadOperator(store: store, load: PaywallsLoader.load)
        store.subscribe(observer: paywallsLoadOperator.asObserver)

        let userNameLoadOperator = UserNameLoadOperator(store: store, load: UserNameLoader.load)
        store.subscribe(observer: userNameLoadOperator.asObserver)

        let userNameCacheOperator = UserNameCacheOperator(
            store: store, cache: UserDefaultsNameCacher.cache, remove: UserDefaultsNameCacher.remove)
        store.subscribe(observer: userNameCacheOperator.asObserver)
    }
}

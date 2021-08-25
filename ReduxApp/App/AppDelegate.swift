import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private let store: Store<AppState, Action>
    private let navigationController = UINavigationController()

    override init() {
        store = Store(initial: .init()) {
            print("Action -> \($1)")
            $0.reduce($1)
        }

        super.init()

        let splashShowOperator = SplashShowOperator(window: window, splash: { SplashViewController() })
        store.subscribe(observer: splashShowOperator.asObserver)

        let remoteConfigFetcherOperator = RemoteConfigFetcherOperator(store: store, fetch: RemoteConfigFetch.run)
        store.subscribe(observer: remoteConfigFetcherOperator.asObserver)

        let enterNameShowOperator = EnterNameShowOperator(store: store, navigationController: navigationController)
        store.subscribe(observer: enterNameShowOperator.asObserver)

        let paywallShowOperator = PaywallShowOperator(store: store, navigationController: navigationController)
        store.subscribe(observer: paywallShowOperator.asObserver)

        let paywallsLoaderOperator = PaywallsLoaderOperator(store: store, load: PaywallsLoader.run)
        store.subscribe(observer: paywallsLoaderOperator.asObserver)

        let userLoadOperator = UserLoaderOperator(store: store)
        store.subscribe(observer: userLoadOperator.asObserver)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        store.dispatch(action: DidFinishLaunch())
        return true
    }
}

import UIKit
import Core
import UI
import Injected
import ReduxStore

@main
class AppDelegate: UIResponder {
    var window: UIWindow?
    
    @Injected(\.analytics) var analytics

    private let store = Store(state: .init(), differ: { $0.diff(from: $1) }, reducer: { $0.reduce($1) })
    private let navigationController = UINavigationController()
}

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        connectOperators()
        store.dispatch(DidFinishLaunch())
        analytics.track("DidFinishLaunch")
        return true
    }
}

// MARK: - Private

private extension AppDelegate {
    func connectOperators() {
        connectSplashShowOperator()
        connectRemoteConfigLoadOperator()
        connectEnterNameShowOperator()
        connectPaywallShowOperator()
        connectPaywallsLoadOperator()
        connectUserNameLoadOperator()
        connectUserNameCacheOperator()
    }
    
    private func connectSplashShowOperator() {
        let op = SplashShowOperator(window: window, splash: { SplashViewController() })
        let observer = Observer(op, ids: [Flow.id]) { state in
            op.process(state)
            return .active
        }
        
        store.subscribe(observer: observer)
    }
    
    private func connectRemoteConfigLoadOperator() {
        let op = RemoteConfigLoadOperator(store: store, fetch: RemoteConfigLoader.load)
        let observer = Observer(op) { state in
            op.process(state)
            return .dead
        }
        
        store.subscribe(observer: observer)
    }
    
    private func connectEnterNameShowOperator() {
        let op = EnterNameShowOperator(store: store, navigationController: navigationController)
        let observer = Observer(op, ids: [Flow.id]) { state in
            op.process(state)
        }
        
        store.subscribe(observer: observer)
    }
    
    private func connectPaywallShowOperator() {
        let op = PaywallShowOperator(store: store, navigationController: navigationController)
        let observer = Observer(op, ids: [Flow.id]) { state in
            op.process(state)
        }
        
        store.subscribe(observer: observer)
    }
    
    private func connectPaywallsLoadOperator() {
        let op = PaywallsLoadOperator(store: store, load: PaywallsLoader.load)
        let observer = Observer(op, ids: [PaywallsLoadingStatus.id]) { state in
            op.process(state)
        }
        
        store.subscribe(observer: observer)
    }
    
    private func connectUserNameLoadOperator() {
        let op = UserNameLoadOperator(store: store, load: UserNameLoader.load)
        let observer = Observer(op, ids: [User.id]) { state in
            op.process(state)
            return .dead
        }
        
        store.subscribe(observer: observer)
    }
    
    private func connectUserNameCacheOperator() {
        let op = UserNameCacheOperator(
            store: store, cache: UserDefaultsNameCacher.cache, remove: UserDefaultsNameCacher.remove)
        let observer = Observer(op, ids: [User.id]) { state in
            op.process(state)
            return .active
        }
        
        store.subscribe(observer: observer)
    }
}

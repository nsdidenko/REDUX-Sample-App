import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private let store: Store<AppState, Action>

    override init() {
        store = Store(initial: .init()) { $0.reduce($1) }
        super.init()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        store.dispatch(action: DidFinishLaunch())
        return true
    }
}

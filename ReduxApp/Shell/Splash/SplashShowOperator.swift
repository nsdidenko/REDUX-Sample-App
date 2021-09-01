import UIKit

public final class SplashShowOperator {
    public typealias Observer = ReduxApp.Observer

    private var window: UIWindow?
    private let splash: () -> UIViewController

    public init(window: UIWindow?, splash: @escaping () -> UIViewController) {
        self.window = window
        self.splash = splash
    }

    private var isLaunchCompleted = false

    public var asObserver: Observer {
        .init {
            self.process($0.flow)
            return .active
        }
    }

    private func process(_ state: Flow) {
        guard state.isLaunchCompleted != isLaunchCompleted else { return }
        isLaunchCompleted = state.isLaunchCompleted

        if isLaunchCompleted {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.makeKeyAndVisible()
            window?.rootViewController = splash()
        }
    }
}

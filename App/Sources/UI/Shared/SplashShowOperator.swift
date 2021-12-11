import UIKit
import Core
import Helpers

public final class SplashShowOperator {
    private var window: UIWindow?
    private let splash: () -> UIViewController

    public init(window: UIWindow?, splash: @escaping () -> UIViewController) {
        self.window = window
        self.splash = splash
    }

    private var isLaunchCompleted = false

    public func process(_ state: AppState) {
        let isLaunchCompleted = state.flow.isLaunchCompleted
        
        guard self.isLaunchCompleted != isLaunchCompleted else { return }
        self.isLaunchCompleted = isLaunchCompleted

        if isLaunchCompleted {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.makeKeyAndVisible()
            window?.rootViewController = splash()
        }
    }
}

import UIKit
import ReduxStore
import Core

public enum SplashUIComposer: Storyboarded {
    public static func compose(store: Store<AppState, Action>) -> SplashViewController {
        let vc = storyboarded(.splash, ofType: SplashViewController.self)
        return vc
    }
}

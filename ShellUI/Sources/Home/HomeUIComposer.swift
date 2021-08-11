import UIKit
import Core
import ReduxStore

public enum HomeUIComposer: Storyboarded {
    public static func compose(store: Store<AppState, Action>) -> HomeViewController {
        let vc = storyboarded(.home, ofType: HomeViewController.self)
        return vc
    }
}

import UIKit
import Core
import ReduxStore

public enum PaywallUIComposer: Storyboarded {
    public static func compose(store: Store<AppState, Action>) -> PaywallViewController {
        let vc = storyboarded(.paywall, ofType: PaywallViewController.self)
        return vc
    }
}

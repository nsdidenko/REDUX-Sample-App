import UIKit
import Core
import ReduxStore

public enum PaywallUIComposer: Storyboarded {
    public static func compose(store: Store<AppState, Action>) -> PaywallViewController {
        let vc = storyboarded(.paywall, ofType: PaywallViewController.self)

        vc.props = .init(
            title: "Paywall",
            action: .init { store.dispatch(action: DidPurchase()) })

        return vc
    }
}

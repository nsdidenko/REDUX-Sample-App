import UIKit

public enum PaywallUIComposer: Storyboarded {
    public static func compose(store: Store) -> PaywallViewController {
        let vc = storyboarded(.paywall, ofType: PaywallViewController.self)

        let uiOperator = PaywallUIOperator(
            store: store,
            render: .init { vc.props = $0 },
            paywallId: "paywall 1")

        store.subscribe(observer: uiOperator.asObserver)

        return vc
    }
}

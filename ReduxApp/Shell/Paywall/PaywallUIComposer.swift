import UIKit

public enum PaywallUIComposer: Storyboarded {
    public static func compose(store: Store<AppState, Action>) -> PaywallViewController {
        let vc = storyboarded(.paywall, ofType: PaywallViewController.self)

        let presenter = PaywallPresenter(
            store: store,
            render: .init { vc.props = $0 },
            paywallId: "paywall 1")

        store.subscribe(observer: presenter.asObserver)

        return vc
    }
}

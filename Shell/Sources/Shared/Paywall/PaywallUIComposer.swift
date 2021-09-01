import UIKit

public enum PaywallUIComposer {
    public static func compose(store: Store) -> PaywallViewController {
        let vc = UIStoryboard.init(name: "Paywall", bundle: Bundle.module)
            .instantiateViewController(withIdentifier: "\(PaywallViewController.self)") as! PaywallViewController

        let uiOperator = PaywallUIOperator(
            store: store,
            render: .init { vc.props = $0 },
            paywallId: "paywall 1")

        store.subscribe(observer: uiOperator.asObserver)

        return vc
    }
}

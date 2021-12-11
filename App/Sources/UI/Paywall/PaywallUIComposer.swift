import UIKit
import Core
import Helpers

public enum PaywallUIComposer {
    public static func compose(store: Store) -> PaywallViewController {
        let vc = UIStoryboard.init(name: "Paywall", bundle: Bundle.module)
            .instantiateViewController(withIdentifier: "\(PaywallViewController.self)") as! PaywallViewController

        let uiOperator = PaywallUIOperator(store: store, paywallId: "paywall 1")
        
        let observer = Observer(uiOperator, ids: uiOperator.idsToObserve) { [weak vc] state in
            guard let vc = vc else { return .dead }
            vc.props = uiOperator.process(state)
            return .active
        }

        store.subscribe(observer: observer)

        return vc
    }
}

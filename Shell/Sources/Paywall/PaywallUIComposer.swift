import UIKit
import Core
import Shared

public enum PaywallUIComposer {
    public static func compose(store: Store) -> PaywallViewController {
        let vc = UIStoryboard.init(name: "Paywall", bundle: Bundle.module)
            .instantiateViewController(withIdentifier: "\(PaywallViewController.self)") as! PaywallViewController

        let uiOperator = PaywallUIOperator(store: store, paywallId: "paywall 1")
        
        let observer = Observer(
            id: typename(PaywallUIOperator.self),
            ids: User.id, PaywallsLoadingStatus.id, AllPaywalls.id)
        { [weak vc] state in
            guard let vc = vc else { return .dead }
            
            vc.props = uiOperator.process(state)
            return .active
        }

        store.subscribe(observer: observer)

        return vc
    }
}

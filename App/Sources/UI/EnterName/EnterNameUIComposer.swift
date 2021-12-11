import UIKit
import Core

public enum EnterNameUIComposer {
    public static func compose(store: Store) -> EnterNameViewController {
        let vc = UIStoryboard.init(name: "EnterName", bundle: Bundle.module)
            .instantiateViewController(withIdentifier: "\(EnterNameViewController.self)") as! EnterNameViewController
        let uiOperator = EnterNameUIOperator(store: store)
        
        let observer = Observer(uiOperator, ids: uiOperator.idsToObserve) { [weak vc] state in
            guard let vc = vc else { return .dead }
            vc.props = uiOperator.process(state)
            return .active
        }

        store.subscribe(observer: observer)

        return vc
    }
}

import UIKit
import Shared
import Core

public enum EnterNameUIComposer {
    public static func compose(store: Store) -> EnterNameViewController {
        let vc = UIStoryboard.init(name: "EnterName", bundle: Bundle.module)
            .instantiateViewController(withIdentifier: "\(EnterNameViewController.self)") as! EnterNameViewController

        let uiOperator = EnterNameUIOperator(
            store: store,
            render: .init { vc.props = $0 })

        store.subscribe(observer: uiOperator.asObserver)

        return vc
    }
}

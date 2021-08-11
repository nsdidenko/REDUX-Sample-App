import UIKit
import Shell

public extension PaywallViewController {
    struct Props {
        let title: String
        let action: Command

        static var initial = Props(title: "", action: .nop)
    }
}

public final class PaywallViewController: UIViewController {
    public var props = Props.initial {
        didSet { view.setNeedsLayout() }
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        title = props.title
    }

    @IBAction func buttonAction(sender: UIButton) {
        props.action.perform()
    }
}

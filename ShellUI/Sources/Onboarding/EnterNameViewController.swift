import UIKit
import Shell

public extension EnterNameViewController {
    struct Props {
        let title: String
        let action: CommandWith<String>

        public init(title: String, action: CommandWith<String>) {
            self.title = title
            self.action = action
        }

        static let initial = Props(title: "", action: .nop)
    }
}

public final class EnterNameViewController: UIViewController {
    public var props: Props = .initial {
        didSet { view.setNeedsLayout() }
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        render()
    }

    @IBAction func buttonAction(sender: UIButton) {
        props.action.perform(with: "Name")
    }

    private func render() {
        title = props.title
    }
}

import UIKit
import Command

public extension EnterNameViewController {
    struct Props {
        public let invalidCaption: InvalidCaption; public struct InvalidCaption {
            let state: State; enum State {
                case shown, hidden
            }
        }
        public let field: EnterNameTextField.Props
        public let button: NextButton.Props
        public let didAppear: Command

        public init(
            invalidCaption: InvalidCaption,
            field: EnterNameTextField.Props,
            button: NextButton.Props,
            didAppear: Command)
        {
            self.invalidCaption = invalidCaption
            self.field = field
            self.button = button
            self.didAppear = didAppear
        }

        static let initial = Props(invalidCaption: .init(state: .hidden), field: .initial, button: .initial, didAppear: .nop)
    }
}

public final class EnterNameViewController: UIViewController {
    public var props: Props = .initial {
        didSet { view.setNeedsLayout() }
    }

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var textField: EnterNameTextField!
    @IBOutlet weak private var invalidLabel: UILabel!
    @IBOutlet weak private var nextButton: NextButton!
    @IBOutlet weak private var nextButtonBottomConstraint: NSLayoutConstraint!

    private var keyboardHandler: KeyboardHandler?

    public override func viewDidLoad() {
        super.viewDidLoad()

        keyboardHandler = KeyboardHandler(in: view, constraint: nextButtonBottomConstraint)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        textField.becomeFirstResponder()
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        render()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        props.didAppear.perform()
    }

    private func render() {
        titleLabel.text = "Please enter the name you would like to use:"
        textField.props = props.field
        nextButton.props = props.button

        invalidLabel.text = "The name must not contain numbers."
        invalidLabel.isHidden = {
            switch props.invalidCaption.state {
            case .shown: return false
            case .hidden: return true
            }
        }()
    }
}

import UIKit

public extension EnterNameViewController {
    struct Props {
        public let title: String
        public let header: String
        public let invalidCaption: InvalidCaption; public struct InvalidCaption {
            let title: String
            let state: State; enum State {
                case shown, hidden
            }
        }
        public let field: EnterNameTextField.Props
        public let button: EnterNameNextButton.Props

        public init(
            title: String,
            header: String,
            invalidCaption: InvalidCaption,
            field: EnterNameTextField.Props,
            button: EnterNameNextButton.Props)
        {
            self.title = title
            self.header = header
            self.invalidCaption = invalidCaption
            self.field = field
            self.button = button
        }

        static let initial = Props(title: "", header: "", invalidCaption: .init(title: "", state: .hidden), field: .initial, button: .initial)
    }
}

public final class EnterNameViewController: UIViewController {
    public var props: Props = .initial {
        didSet { view.setNeedsLayout() }
    }

    @IBOutlet weak private var headerLabel: UILabel!
    @IBOutlet weak private var textField: EnterNameTextField!
    @IBOutlet weak private var invalidLabel: UILabel!
    @IBOutlet weak private var nextButton: EnterNameNextButton!
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

    private func render() {
        title = props.title
        headerLabel.text = props.header
        textField.props = props.field
        nextButton.props = props.button

        invalidLabel.text = props.invalidCaption.title
        invalidLabel.isHidden = {
            switch props.invalidCaption.state {
            case .shown: return false
            case .hidden: return true
            }
        }()
    }
}

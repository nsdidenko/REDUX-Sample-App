import UIKit

public extension EnterNameViewController {
    struct Props {
        let title: String
        let header: String
        let field: EnterNameTextField.Props
        let button: EnterNameNextButton.Props

        public init(
            title: String,
            header: String,
            field: EnterNameTextField.Props,
            button: EnterNameNextButton.Props)
        {
            self.title = title
            self.header = header
            self.field = field
            self.button = button
        }

        static let initial = Props(title: "", header: "", field: .initial, button: .initial)
    }
}

public final class EnterNameViewController: UIViewController {
    public var props: Props = .initial {
        didSet { view.setNeedsLayout() }
    }

    @IBOutlet weak private var headerLabel: UILabel!
    @IBOutlet weak private var textField: EnterNameTextField!
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
    }
}

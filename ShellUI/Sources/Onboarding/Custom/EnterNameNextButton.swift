import UIKit
import Shell

public extension EnterNameNextButton {
    struct Props {
        public let title: String
        public let state: State; public enum State {
            case active(Command)
            case inactive
        }

        public init(title: String, state: EnterNameNextButton.Props.State) {
            self.title = title
            self.state = state
        }

        static let initial = Props(title: "", state: .inactive)
    }
}

public final class EnterNameNextButton: UIButton {
    public var props = Props.initial {
        didSet { render() }
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        setup()
    }

    private func setup() {
        layer.cornerRadius = 6
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        addTarget(self, action: #selector(handle), for: .touchUpInside)
    }

    private func render() {
        setTitle(props.title, for: .normal)

        backgroundColor = {
            switch props.state {
            case .inactive: return .lightGray.withAlphaComponent(0.3)
            case .active: return .blue
            }
        }()

        isUserInteractionEnabled = {
            switch props.state {
            case .inactive: return false
            case .active: return true
            }
        }()

    }

    @objc private func handle() {
        if case let .active(command) = props.state {
            command.perform()
        }
    }
}

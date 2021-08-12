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
        addTarget(self, action: #selector(handle), for: .touchUpInside)
    }

    private func render() {
        setTitle(props.title, for: .normal)

        setTitleColor({
            switch props.state {
            case .inactive: return .white
            case .active: return .blue
            }
        }(), for: .normal)

        backgroundColor = {
            switch props.state {
            case .inactive: return .lightGray.withAlphaComponent(0.3)
            case .active: return .clear
            }
        }()

        layer.borderColor = {
            switch props.state {
            case .inactive: return UIColor.clear.cgColor
            case .active: return UIColor.blue.cgColor
            }
        }()

        layer.borderWidth = {
            switch props.state {
            case .inactive: return 0
            case .active: return 1
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

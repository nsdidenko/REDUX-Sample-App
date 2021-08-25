import UIKit

public extension PlanButton {
    struct Props: Equatable {
        public let title: String
        public let state: State; public enum State: Equatable {
            case active, inactive
        }
        public let action: Command

        public init(title: String, state: State, action: Command) {
            self.title = title
            self.state = state
            self.action = action
        }

        static let initial = Props(title: "", state: .inactive, action: .nop)

        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.title == rhs.title && lhs.state == rhs.state
        }
    }
}

public final class PlanButton: UIButton {
    public var props = Props.initial {
        didSet { render() }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        setup()
    }

    private func setup() {
        layer.cornerRadius = 6
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
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
    }

    @objc private func handle() {
        props.action.perform()
    }
}

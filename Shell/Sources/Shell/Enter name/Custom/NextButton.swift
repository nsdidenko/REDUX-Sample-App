import UIKit

public extension NextButton {
    struct Props: Equatable {
        public let title: String
        public let state: State; public enum State: Equatable {
            case active(Command)
            case inactive

            var isInactive: Bool {
                self == .inactive
            }
        }

        public init(title: String, state: State) {
            self.title = title
            self.state = state
        }

        static let initial = Props(title: "", state: .inactive)

        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.title == rhs.title && lhs.state.isInactive == rhs.state.isInactive
        }
    }
}

public final class NextButton: UIButton {
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

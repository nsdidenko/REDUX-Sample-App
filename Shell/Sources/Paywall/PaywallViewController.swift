import UIKit
import Shared

public extension PaywallViewController {
    struct Props: Equatable {
        public let title: String
        public let state: State; public enum State: Equatable {
            case loading
            case active([PlanButton.Props])
        }
        public let button: NextButton.Props

        public init(title: String, state: State, button: NextButton.Props) {
            self.title = title
            self.state = state
            self.button = button
        }

        static var initial = Props(title: "", state: .loading, button: .initial)
    }
}

public final class PaywallViewController: UIViewController {
    public var props = Props.initial {
        didSet {
            guard isViewLoaded else { return }
            render()
        }
    }

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var activity: UIActivityIndicatorView!
    @IBOutlet weak private var plansStackView: UIStackView!
    @IBOutlet weak private var purchaseButton: NextButton!

    private func render() {
        titleLabel.text = props.title

        set(activity) {
            switch props.state {
            case .loading: return $0.startAnimating()
            case .active: return $0.stopAnimating()
            }
        }

        set(plansStackView) { stackView in
            stackView.arrangedSubviews.forEach { subview in
                subview.removeFromSuperview()
            }

            if case let .active(plans) = props.state {
                plans.forEach { planProps in
                    let button = PlanButton()
                    button.props = planProps
                    button.translatesAutoresizingMaskIntoConstraints = false
                    stackView.addArrangedSubview(button)
                    view.addConstraints([
                        button.heightAnchor.constraint(equalToConstant: 80)
                    ])
                }
            }
        }

        purchaseButton.props = props.button
    }
}

private func set<T: UIView>(_ view: T, completion: (T) -> Void) {
    completion(view)
}

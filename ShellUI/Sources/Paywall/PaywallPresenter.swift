import UIKit
import Shell
import ReduxStore
import Core

public struct PaywallPresenter {
    public typealias Store = ReduxStore.Store<AppState, Action>
    public typealias Props = PaywallViewController.Props

    let store: Store
    let render: CommandWith<Props>

    public init(store: Store, render: CommandWith<Props>) {
        self.store = store
        self.render = render
    }

    public func process(_ state: Paywall) {
        let props = Props(
            title: "Dear Friend, we have a special offer for you!",
            state: map(state),
            button: .init(title: "Purchase", state: map(state)))

        render.perform(with: props)
    }

    // MARK: - Private

    private func map(_ paywall: Paywall) -> Props.State {
        switch paywall {
        case .loading:
            return .loading

        case let .ready(subscriptions):
            return .active(subscriptions.all().map { map($0, selected: $0 == subscriptions.selected) })
        }
    }

    private func map(_ subscription: Subscription, selected: Bool) -> PlanButton.Props {
        .init(title: "\(subscription.localizedPrice())",
              state: selected ? .active : .inactive,
              action: .init { store.dispatch(action: DidSelectPaywallOption(subscription: subscription)) })
    }

    private func map(_ paywall: Paywall) -> NextButton.Props.State {
        switch paywall {
        case .loading:
            return .inactive

        case .ready:
            return .active(.init { store.dispatch(action: DidPurchase()) })
        }
    }
}

private extension Subscription {
    func localizedPrice(dividedBy divider: Decimal = 1) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        let dividedDecimal = price / divider
        let decimalNumberPrice = NSDecimalNumber(decimal: dividedDecimal)
        return formatter.string(from: decimalNumberPrice)!
    }
}

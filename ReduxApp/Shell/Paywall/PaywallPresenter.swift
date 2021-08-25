import UIKit

public struct PaywallPresenter {
    public typealias Props = PaywallViewController.Props

    let store: Store<AppState, Action>
    let render: CommandWith<Props>
    let paywallId: String

    public init(store: Store<AppState, Action>, render: CommandWith<Props>, paywallId: String) {
        self.store = store
        self.render = render
        self.paywallId = paywallId
    }

    public var asObserver: Observer<AppState> {
        .init {
            self.process($0)
            return .active
        }
    }

    public func process(_ state: AppState) {
        let props = Props(
            title: "\(state.user.name), we have a special offer for you!",
            state: map(state.allPaywalls),
            button: .init(title: "Purchase", state: map(state.allPaywalls)))

        render.perform(with: props)
    }

    // MARK: - Private

    private func paywall(from allPaywalls: AllPaywalls) -> Paywall? {
        allPaywalls.paywalls.filter({ $0.id == paywallId }).first
    }

    private func map(_ allPaywalls: AllPaywalls) -> Props.State {
        switch allPaywalls.status {
        case .idle, .loading:
            return .loading

        case .ready:
            if let paywall = paywall(from: allPaywalls) {
                return .active(paywall.inAppProducts.enumerated().map { i, inAppProduct in
                    let chosenId = allPaywalls.chosen[paywallId]
                    return map(inAppProduct, index: i, selected: i == chosenId)
                })
            } else {
                return .active([])
            }
        }
    }

    private func map(_ inAppProduct: InAppProduct, index: Int, selected: Bool) -> PlanButton.Props {
        .init(title: "\(inAppProduct.localizedPrice())",
              state: selected ? .active : .inactive,
              action: .init { store.dispatch(action: DidSelectInAppProduct(at: index, in: paywallId)) })
    }

    private func map(_ allPaywalls: AllPaywalls) -> NextButton.Props.State {
        switch allPaywalls.status {
        case .idle, .loading:
            return .inactive

        case .ready:
            return .active(.init { store.dispatch(action: DidPurchase()) })
        }
    }
}

private extension InAppProduct {
    func localizedPrice(dividedBy divider: Decimal = 1) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = price.locale
        let dividedDecimal = price.value / divider
        let decimalNumberPrice = NSDecimalNumber(decimal: dividedDecimal)
        return formatter.string(from: decimalNumberPrice)!
    }
}

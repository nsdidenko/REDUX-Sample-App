import UIKit
import Core

public struct PaywallUIOperator {
    public typealias Props = PaywallViewController.Props

    let store: Store
    let render: CommandWith<Props>
    let paywallId: String

    public init(store: Store, render: CommandWith<Props>, paywallId: String) {
        self.store = store
        self.render = render
        self.paywallId = paywallId
    }

    public var asObserver: Observer {
        .init {
            self.process($0)
            return .active
        }
    }

    // MARK: - Private

    private func process(_ state: AppState) {
        let props = Props(
            title: "\(state.user.name), we have a special offer for you!",
            state: map(state.allPaywalls, loadingStatus: state.paywallsLoadingStatus),
            button: .init(title: "Purchase", state: map(state.paywallsLoadingStatus)))

        render.perform(with: props)
    }

    private func paywall(from allPaywalls: AllPaywalls) -> Paywall? {
        allPaywalls.paywalls.filter({ $0.id == paywallId }).first
    }

    private func map(_ allPaywalls: AllPaywalls, loadingStatus: PaywallsLoadingStatus) -> Props.State {
        switch loadingStatus {
        case .idle, .loading:
            return .loading

        case .ready:
            if let paywall = paywall(from: allPaywalls) {
                return .active(paywall.inAppProducts.enumerated().map { i, inAppProduct in
                    map(inAppProduct, index: i, selected: i == paywall.chosen)
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

    private func map(_ loadingStatus: PaywallsLoadingStatus) -> NextButton.Props.State {
        switch loadingStatus {
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

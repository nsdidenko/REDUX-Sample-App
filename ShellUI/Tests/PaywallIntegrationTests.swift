import Foundation
import XCTest
import ReduxStore
import Core
import ShellUI
import Shell

final class PaywallIntegrationTests: XCTestCase {

    func test_loading() {
        var state = AppState()

        expect(
            givenInitialState: &state,
            whenCallActions: [],
            thenExpectPropsState: .loading,
            andButtonState: .inactive)
    }

    func test_didLoadSubscriptions() {
        var state = AppState()

        expect(
            givenInitialState: &state,
            whenCallActions: [
                DidLoadSubscriptions(subscriptions: [
                    .init(id: "s1", price: 9.99, locale: .init(identifier: "en_US")),
                    .init(id: "s2", price: 16.99, locale: .init(identifier: "en_US")),
                    .init(id: "s3", price: 49.99, locale: .init(identifier: "en_US"))
                ])
            ],
            thenExpectPropsState: .active([
                .init(title: "$9.99", state: .active, action: .nop),
                .init(title: "$16.99", state: .inactive, action: .nop),
                .init(title: "$49.99", state: .inactive, action: .nop)
            ]),
            andButtonState: .active(.nop))
    }

    func test_didSelectPaywallOption_multipleTimes() {
        let s1 = Subscription(id: "s1", price: 9.99, locale: .init(identifier: "en_US"))
        let s2 = Subscription(id: "s2", price: 16.99, locale: .init(identifier: "en_US"))
        let s3 = Subscription(id: "s3", price: 49.99, locale: .init(identifier: "en_US"))

        var state = AppState(paywall: .ready(.init(head: [], selected: s1, rest: [s2, s3])))

        expect(
            givenInitialState: &state,
            whenCallActions: [
                DidSelectPaywallOption(subscription: s2),
                DidSelectPaywallOption(subscription: s3),
                DidSelectPaywallOption(subscription: s2),
            ],
            thenExpectPropsState: .active([
                .init(title: "$9.99", state: .inactive, action: .nop),
                .init(title: "$16.99", state: .active, action: .nop),
                .init(title: "$49.99", state: .inactive, action: .nop)
            ]),
            andButtonState: .active(.nop))
    }

    // MARK: - Helpers

    private func expect(
        givenInitialState state: inout AppState,
        whenCallActions actions: [Action],
        thenExpectPropsState propsState: PaywallViewController.Props.State,
        andButtonState buttonState: NextButton.Props.State
    ) {
        let store = Store<AppState, Action>(initial: state) { $0.reduce($1) }

        let exp = expectation(description: "Wait for notification.")
        exp.expectedFulfillmentCount = actions.count + 1
        let vc = PaywallUIComposer.compose(store: store) {
            exp.fulfill()
        }

        actions.forEach {
            store.dispatch(action: $0)
        }

        wait(for: [exp], timeout: 0.1)

        let expectedProps = PaywallViewController.Props(
            title: "Dear Friend, we have a special offer for you!",
            state: propsState,
            button: .init(title: "Purchase", state: buttonState))

        assertEqual(expected: expectedProps, actual: vc.props)
    }
}











































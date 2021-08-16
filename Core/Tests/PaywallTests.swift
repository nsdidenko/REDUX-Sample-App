import Foundation
import XCTest
import Core

final class PaywallTests: XCTestCase {
    func test_didLoadSubscriptions() {
        var state = Paywall()
        let (s1, s2, s3) = (Subscription(id: "s1"), Subscription(id: "s2"), Subscription(id: "s3"))

        state.reduce(DidLoadSubscriptions(subscriptions: [
            s1, s2, s3
        ]))

        assertEqual(
            expected: .ready(.init(head: [], selected: s1, rest: [s2, s3])),
            actual: state)
    }

    func test_didSelectPaywallOption() {
        let (s1, s2, s3) = (Subscription(id: "s1"), Subscription(id: "s2"), Subscription(id: "s3"))
        var state = Paywall.ready(.init(head: [], selected: s1, rest: [s2, s3]))

        select(subscription: s2, andExpectHead: [s1], selected: s2, rest: [s3], forState: &state)
        select(subscription: s2, andExpectHead: [s1], selected: s2, rest: [s3], forState: &state)

        select(subscription: s3, andExpectHead: [s1, s2], selected: s3, rest: [], forState: &state)
        select(subscription: s3, andExpectHead: [s1, s2], selected: s3, rest: [], forState: &state)

        select(subscription: s1, andExpectHead: [], selected: s1, rest: [s2, s3], forState: &state)
        select(subscription: s1, andExpectHead: [], selected: s1, rest: [s2, s3], forState: &state)

        select(subscription: s2, andExpectHead: [s1], selected: s2, rest: [s3], forState: &state)
    }

    // MARK: - Helpers

    private func select(
        subscription: Subscription,
        andExpectHead head: [Subscription],
        selected: Subscription,
        rest: [Subscription],
        forState state: inout Paywall
    ) {
        state.reduce(DidSelectPaywallOption(subscription: subscription))

        assertEqual(
            expected: .ready(.init(head: head, selected: selected, rest: rest)),
            actual: state)
    }
}

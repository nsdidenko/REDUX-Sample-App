import Foundation
import XCTest
import Shell
import ReduxStore
import Core

final class LoadSubscriptionsOperatorTests: XCTestCase {
    func test_didLoadSubscriptions() {
        let exp = expectation(description: "Wait for notification")

        let store = Store<AppState, Action>(initial: .init()) {
            $0.reduce($1)
            exp.fulfill()
        }

        let s1 = Subscription(id: "s1", price: 9.99, locale: .init(identifier: "en_US"))
        let s2 = Subscription(id: "s2", price: 16.99, locale: .init(identifier: "en_US"))
        let s3 = Subscription(id: "s3", price: 49.99, locale: .init(identifier: "en_US"))

        let subscriptions: [Subscription] = [ s1, s2, s3 ]

        func load(completion: @escaping ([Subscription]) -> Void) {
            completion(subscriptions)
        }

        store.subscribeLoadSubscriptionsOperator(load: load)

        wait(for: [exp], timeout: 0.1)

        let expectedState = AppState(
            paywall: .ready(.init(head: [], selected: s1, rest: [s2, s3])),
            lastSomeAction: .didLoadSubscriptions(DidLoadSubscriptions(subscriptions: subscriptions)))

        assertEqual(expected: expectedState, actual: store.state)
    }
}

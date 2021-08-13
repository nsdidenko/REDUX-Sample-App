import Foundation
import XCTest
import Shell
import ReduxStore
import Core

final class DefineStartFlowOperatorTests: XCTestCase {

    func test_skipOnboarding() {
        expect([ .launching, .splash, .home ], whenSkipOnboarding: true)
    }

    func test_notSkipOnboarding() {
        expect([ .launching, .splash, .onboarding, .home ], whenSkipOnboarding: false)
    }

    // MARK: - Helpers

    private func expect(_ checkPoints: [Flow.CheckPoint], whenSkipOnboarding flag: Bool) {
        let id = UUID()
        let exp = expectation(description: "Wait for notification")

        let store = Store<AppState, Action>(
            initial: .init(
                flow: .init(checkPoints: [], currentCheckPoint: .launching),
                user: .init(name: .init(id: id))))
        {
            $0.reduce($1)
            exp.fulfill()
        }

        store.subscribeFlowLoadOperator(skipOnboarding: { flag })

        wait(for: [exp], timeout: 0.1)

        let expectedState = AppState(
            flow: .init(checkPoints: checkPoints, currentCheckPoint: .launching),
            user: .init(name: .init(id: id)),
            lastSomeAction: .skipOnboarding(SkipOnboarding(flag: flag)))

        assertEqual(expected: expectedState, actual: store.state)
    }
}

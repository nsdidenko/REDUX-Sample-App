import Foundation
import XCTest
import Shell
import ReduxStore
import Core

final class FirebaseOperatorTests: XCTestCase {

    func test_afterSplashComesHome() {
        afterSplashExpect(.home, whenAll: [ .launching, .splash, .home ])
    }

    func test_afterSplashComesOnboarding() {
        afterSplashExpect(.onboarding, whenAll: [ .launching, .splash, .onboarding, .home ])
    }

    // MARK: - Helpers

    private typealias CheckPoint = Flow.CheckPoint

    private func afterSplashExpect(_ checkPoint: CheckPoint, whenAll checkPoints: [CheckPoint]) {
        let exp = expectation(description: "Wait for notification")

        let startFlow = Flow(checkPoints: checkPoints, currentCheckPoint: .splash)
        let store = Store<AppState, Action>(initial: .init(flow: startFlow)) {
            $0.reduce($1)
            exp.fulfill()
        }

        func fetch(completion: @escaping () -> Void) {
            completion()
        }

        store.subscribeFirebaseOperator(fetch: fetch)

        wait(for: [exp], timeout: 0.1)

        let expectedState = AppState(
            flow: .init(checkPoints: checkPoints, currentCheckPoint: checkPoint),
            lastSomeAction: .didLoadRemoteConfig(DidLoadRemoteConfig()))

        assertEqual(expected: expectedState, actual: store.state)
    }
}

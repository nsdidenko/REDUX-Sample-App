import Foundation
import XCTest
import ReduxStore
import Core
import ShellUI

final class UIWindowOperatorTests: XCTestCase {
    func test_didLoadRemoteConfig_providesNextRoot() {
        expectNextRoot(on: DidLoadRemoteConfig(),
                       whenCurrentCheckPoint: .splash,
                       andAllCheckPoints: [ .launching, .splash, .home ])
    }

    func test_didPurhcase_providesNextRoot() {
        expectNextRoot(on: DidPurchase(),
                       whenCurrentCheckPoint: .onboarding,
                       andAllCheckPoints: [ .launching, .splash, .onboarding, .home ])
    }

    // MARK: - Helpers

    private typealias CheckPoint = Flow.CheckPoint

    private func expectNextRoot(on action: Action, whenCurrentCheckPoint checkPoint: CheckPoint, andAllCheckPoints checkPoints: [CheckPoint]) {
        let initialState = AppState(flow: .init(checkPoints: checkPoints, currentCheckPoint: checkPoint))
        let store = Store<AppState, Action>(initial: initialState) { $0.reduce($1) }
        let nextRootVC = UIViewController()
        let window = UIWindow()
        let op = UIWindowOperator(window: { window }) { _ in nextRootVC }

        let exp = expectation(description: "Wait for notification")
        exp.expectedFulfillmentCount = 2

        store.subscribe(observer: .init(action: {
            op.process($0.flow.currentCheckPoint)
            exp.fulfill()
        }).dispatched(on: .main))

        store.dispatch(action: action)

        wait(for: [exp], timeout: 0.1)

        XCTAssertEqual(nextRootVC, window.rootViewController)
    }
}

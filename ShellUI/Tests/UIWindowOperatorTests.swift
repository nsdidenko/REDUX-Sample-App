import Foundation
import XCTest
import ReduxStore
import Core
import ShellUI

final class UIWindowOperatorTests: XCTestCase {
    
    func test_didLoadRemoteConfig_providesNextRootInLongFlow() {
        expectNextRoot(whenCheckPoints: [ .launching, .splash, .onboarding, .home ])
    }

    func test_didLoadRemoteConfig_providesNextRootInShortFlow() {
        expectNextRoot(whenCheckPoints: [ .launching, .splash, .home ])
    }

    // MARK: - Helpers

    private typealias CheckPoint = Flow.CheckPoint

    private func expectNextRoot(whenCheckPoints checkPoints: [CheckPoint]) {
        let initialState = AppState(flow: .init(checkPoints: checkPoints, currentCheckPoint: .splash))
        let store = Store<AppState, Action>(initial: initialState) { $0.reduce($1) }
        let window = UIWindow()
        let mapper = CheckPointToVCMapper(store: store, nc: .init())
        var nextRootVC: UIViewController?
        let op = UIWindowOperator(window: { window }) { checkPoint in
            let vc = mapper.map(checkPoint)
            nextRootVC = vc
            return vc
        }

        let exp = expectation(description: "Wait for notification")
        exp.expectedFulfillmentCount = 2

        store.subscribe(observer: .init(action: {
            op.process($0.flow.currentCheckPoint)
            exp.fulfill()
        }).dispatched(on: .main))

        store.dispatch(action: DidLoadRemoteConfig())

        wait(for: [exp], timeout: 0.1)

        XCTAssertNotNil(nextRootVC)
        XCTAssertNotNil(window.rootViewController)
        XCTAssertEqual(nextRootVC, window.rootViewController)
    }
}

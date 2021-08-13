import Foundation
import XCTest
import ShellUI
import ReduxStore
import Core

final class OnboardingNavigationOperatorTests: XCTestCase {
    func test_didEnterName_providesPushNextVC() {
        let initialVC = UIViewController()
        let store = Store<AppState, Action>(initial: .init()) { $0.reduce($1) }
        let navigationController = NavigationController(rootViewController: initialVC)
        let nextVC = UIViewController()
        let op = OnboardingNavigationOperator(navigationController: navigationController, nextVC: { nextVC })

        let exp = expectation(description: "Wait for notification")
        exp.expectedFulfillmentCount = 2

        store.subscribe(observer: .init {
            op.process($0.user)
            exp.fulfill()
        }.dispatched(on: .main))

        store.dispatch(action: DidEnterName(.init(value: "Bob")))

        wait(for: [exp], timeout: 0.1)

        XCTAssertEqual([initialVC, nextVC], navigationController.viewControllers)
    }

    // MARK: - Helpers

    private class NavigationController: UINavigationController {
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: false)
        }
    }
}

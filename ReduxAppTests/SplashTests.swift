import XCTest
import ReduxApp

class SplashTests: XCTestCase {

    func test_didFinishLaunch_providesSplash() {
        let exp = expectation(description: "Wait for notificaion")
        let store = Store(initial: .init()) { state, action in
            state.reduce(action)
            exp.fulfill()
        }
        let vc = SplashViewController()
        let op = SplashShowOperator(window: nil, splash: { vc })
        store.subscribe(observer: op.asObserver)

        store.dispatch(action: DidFinishLaunch())

        wait(for: [exp], timeout: 0.1)

        let window = UIApplication.shared.windows.first!

        XCTAssertTrue(window.isKeyWindow)
        XCTAssertNotNil(window.rootViewController)
    }
}

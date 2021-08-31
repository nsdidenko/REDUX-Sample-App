import XCTest
import ReduxApp

class UserNameLoadTests: XCTestCase {

    func test_subscribe_providesUserNameLoad() {
        let store = Store<AppState, Action>(initial: .init()) { $0.reduce($1) }
        let name = "Some-name"

        let exp = expectation(description: "Wait for notificaion")
        func loadName(completion: @escaping (String) -> Void) {
            completion(name)
            exp.fulfill()
        }

        let op = UserNameLoadOperator(store: store, load: loadName)
        store.subscribe(observer: op.asObserver)

        wait(for: [exp], timeout: 0.1)

        XCTAssertEqual(name, store.state.user.name)
    }

}

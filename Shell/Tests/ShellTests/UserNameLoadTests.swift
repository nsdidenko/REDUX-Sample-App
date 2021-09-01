import XCTest
import Shared

class UserNameLoadTests: XCTestCase {

    func test_subscribe_providesUserNameLoadOnes() {
        let store = Store(initial: .init()) { $0.reduce($1) }
        let name = "Some-name"

        let exp = expectation(description: "Wait for notificaion")
        func loadName(completion: @escaping (String) -> Void) {
            completion(name)
            exp.fulfill()
        }

        let op = UserNameLoadOperator(store: store, load: loadName)
        let observer = op.asObserver
        store.subscribe(observer: observer)
        var observersAfterSubscribe = store.observers

        wait(for: [exp], timeout: 0.1)

        observersAfterSubscribe.remove(observer)

        XCTAssertEqual(name, store.state.user.name)
        XCTAssertEqual(observersAfterSubscribe, store.observers)
    }

}

import XCTest
import ReduxApp

class UserNameCacheTests: XCTestCase {

    func test() {
        let store = Store(initial: .init()) { $0.reduce($1) }
        let oldName = "Bobby"
        let newName = "Bob"

        var cachedNames = [String]()
        var cache: (String) -> Void {
            return { cachedNames.append($0) }
        }

        let exp = expectation(description: "Wait for notification")
        exp.expectedFulfillmentCount = 2
        var removeCallsCount = 0
        var remove: () -> Void {
            return {
                removeCallsCount += 1
                exp.fulfill()
            }
        }

        let op = UserNameCacheOperator(store: store, cache: cache, remove: remove)
        store.subscribe(observer: op.asObserver)
        let observersAfterSubscribe = store.observers

        store.dispatch(action: DidLoadName(""))
        store.dispatch(action: DidSetName(oldName))
        store.dispatch(action: DidSetName(""))
        store.dispatch(action: DidSetName(""))
        store.dispatch(action: DidSetName(newName))
        store.dispatch(action: DidSetName(""))

        wait(for: [exp], timeout: 0.1)

        XCTAssertEqual([oldName, newName], cachedNames)
        XCTAssertEqual(removeCallsCount, 2)
        XCTAssertEqual(observersAfterSubscribe, store.observers)
    }
}

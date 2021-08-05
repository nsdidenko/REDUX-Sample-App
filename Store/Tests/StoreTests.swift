import Foundation
import ReduxStore
import XCTest

final class StoreTests: XCTestCase {
    func test_init_doesntHaveSideEffectsOnObservers() {
        let initial = AppState()

        let store = Store<AppState, Action>(initial: initial) { state, action in
            state.reduce(action)
            XCTFail("Reduce must be called only after fired action.")
        }

        trackForMemoryLeaks(store)

        XCTAssertEqual([], store.observers)
    }

    func test_subscribe_updatesObserversWithCurrentStateInStore() {
        let initial = AppState()

        let store = Store<AppState, Action>(initial: initial) { state, action in
            state.reduce(action)
            XCTFail("Reduce must be called only after fired action.")
        }

        var updatedStates: [AppState] = []

        let exp1 = expectation(description: "Wait for state update after observer subscribed.")
        let observer1 = Observer<AppState> { state in
            updatedStates.append(state)
            exp1.fulfill()
        }

        let exp2 = expectation(description: "Wait for state update after observer subscribed.")
        let observer2 = Observer<AppState> { state in
            updatedStates.append(state)
            exp2.fulfill()
        }

        store.subscribe(observer: observer1)
        store.subscribe(observer: observer2)

        waitForExpectations(timeout: 0.1)

        trackForMemoryLeaks(store)

        XCTAssertEqual([initial, initial], updatedStates)
        XCTAssertEqual([observer1, observer2], store.observers)
    }

    func test_dispatch_reducesActions() {
        let initial = AppState()
        let action = AnyAction()
        var dispatchedActions: [Action] = []

        let exp = expectation(description: "Wait for reduce")
        exp.expectedFulfillmentCount = 2

        let store = Store<AppState, Action>(initial: initial) { state, action in
            state.reduce(action)
            dispatchedActions.append(action)
            exp.fulfill()
        }

        store.dispatch(action: action)
        store.dispatch(action: action)

        wait(for: [exp], timeout: 0.1)

        trackForMemoryLeaks(store)

        XCTAssertEqual(2, dispatchedActions.count)
    }

    func test_dispatch_notifiesObserver() {
        let store = makeSUT()

        let exp = expectation(description: "Wait for observer notification.")
        exp.expectedFulfillmentCount = 2

        var updatedStates: [AppState] = []
        let observer = Observer<AppState> { state in
            updatedStates.append(state)
            exp.fulfill()
        }

        store.subscribe(observer: observer)
        store.dispatch(action: AnyAction())

        wait(for: [exp], timeout: 0.1)

        XCTAssertEqual([.init(), .init()], updatedStates)
    }

    // MARK: - Private

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> Store<AppState, Action> {
        let initial = AppState()
        let store = Store<AppState, Action>(initial: initial) { state, action in
            state.reduce(action)
        }

        trackForMemoryLeaks(store, file: file, line: line)

        return store
    }

    private struct AppState: Equatable {
        func reduce(_ action: Action) {}
    }

    private struct AnyAction: Action {}
}

private protocol Action {}

import Foundation

public final class Store<State, Action> {
    public typealias Reducer = (inout State, Action) -> Void

    public private(set) var observers: Set<Observer<State>> = []
    public private(set) var state: State

    private let queue = DispatchQueue(label: "Store queue", qos: .userInitiated)
    private let reducer: Reducer

    public init(initial state: State, reducer: @escaping Reducer) {
        self.state = state
        self.reducer = reducer
    }

    public func dispatch(action: Action) {
        queue.sync {
            self.reducer(&self.state, action)
            self.observers.forEach(self.notify)
        }
    }

    public func subscribe(observer: Observer<State>) {
        queue.sync {
            self.observers.insert(observer)
            self.notify(observer)
        }
    }

    private func notify(_ observer: Observer<State>) {
        let state = self.state
        observer.queue.async {
            let status = observer.process(state)

            if case .dead = status {
                self.queue.async {
                    self.observers.remove(observer)
                }
            }
        }
    }
}

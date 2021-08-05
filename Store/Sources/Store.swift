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
        queue.async {
            self.reducer(&self.state, action)
            self.observers.forEach { $0.perform(with: self.state) }
        }
    }

    @discardableResult
    public func subscribe(observer: Observer<State>) -> Observer<Void> {
        queue.async {
            self.observers.insert(observer)
            observer.perform(with: self.state)
        }

        let endObserving = Observer { [weak observer] in
            guard let observer = observer else { return }
            self.observers.remove(observer)
        }
        .dispatched(on: queue)

        return endObserving
    }
}

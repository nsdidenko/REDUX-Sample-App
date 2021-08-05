import Foundation

final class Store<State, Action> {
    typealias Reducer = (inout State, Action) -> Void

    var observers: Set<Observer<State>> = []
    var state: State

    private let queue = DispatchQueue(label: "Store queue", qos: .userInitiated)
    private let reducer: Reducer

    init(initial state: State, reducer: @escaping Reducer) {
        self.state = state
        self.reducer = reducer
    }

    func dispatch(action: Action) {
        queue.async {
            self.reducer(&self.state, action)
            self.observers.forEach { $0.perform(with: self.state) }
        }
    }

    @discardableResult
    func subscribe(observer: Observer<State>) -> Observer<Void> {
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

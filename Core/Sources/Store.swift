import Foundation

public final class Store {
    public init() {}
    
    public private(set) var state = AppState()
    
    private let queue = DispatchQueue(label: "Store queue", qos: .userInitiated)
    
    private var observers: Set<Observer> = []
    private var previousState: AppState?
    private var changed = [String]()

    public func dispatch(action: Action) {
        queue.sync {
            self.previousState = state
            state.reduce(action)
            changed = state.diff(from: previousState!)
            print("[Store]\nAction: \(action)\nChanged: \(changed)\n")
            self.observers.forEach(self.notifyExact)
            previousState = nil
            changed = []
        }
    }

    public func subscribe(observer: Observer) {
        queue.sync {
            self.observers.insert(observer)
            self.notify(observer)
        }
    }
    
    private func notifyExact(_ observer: Observer) {
        for id in observer.ids where changed.contains(id) {
            notify(observer)
        }
    }

    private func notify(_ observer: Observer) {
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

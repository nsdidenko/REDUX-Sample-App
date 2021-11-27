import Foundation

public final class Store {
    public init() {}
    
    public private(set) var state = AppState() {
        didSet { changed = state.diff(from: oldValue) }
    }
    
    private let queue = DispatchQueue(label: "Store queue", qos: .userInitiated)
    
    private var observers: Set<Observer> = []
    private var changed = [String]()

    public func dispatch(action: Action) {
        queue.sync {
            state.reduce(action)
            print("[Store]\nAction: \(action)\nChanged: \(changed)\n")
            self.observers.forEach(self.notifyExact)
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

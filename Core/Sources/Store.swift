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
        queue.async {
            self.state.reduce(action)
            self.notifyAll(after: action)
            self.changed = []
        }
    }

    public func subscribe(observer: Observer) {
        queue.async {
            self.observers.insert(observer)
            self.notify(observer)
        }
    }
    
    private func notifyAll(after action: Action) {
        let notified = observers.compactMap { notifyExact($0) ?? nil }
        printInfo(after: action, notified: notified)
    }
    
    private func notifyExact(_ observer: Observer) -> String? {
        if needToNotify(observer: observer) {
            notify(observer)
            return observer.id
        }
        
        return nil
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

private extension Store {
    func needToNotify(observer: Observer) -> Bool {
        if observer.ids.isEmpty {
            return true
        } else {
            for id in observer.ids where changed.contains(id) {
                return true
            }
        }
        
        return false
    }
    
    func printInfo(after action: Action, notified: [String]) {
        let info = """
        
        - Action   : \(action)
        - Changed  : \(changed)
        - Notified : \(notified)
        
        """.withoutBrackets
        
        print("---------------[Store]---------------\n".appending(info))
    }
}

extension String {
    var withoutBrackets: String {
        replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
    }
}

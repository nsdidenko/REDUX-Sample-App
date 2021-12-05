import Foundation

public final class Store<State, Action> {
    public typealias Differ = (State, State) -> [String]
    public typealias Reducer = (inout State, Action) -> Void
    
    public private(set) var state: State {
        didSet { changed = differ(state, oldValue) }
    }
    
    private let queue = DispatchQueue(label: "Store queue", qos: .userInitiated)
    private let differ: Differ
    private let reducer: Reducer
    private var observers: Set<Observer<State>> = []
    private var changed = [String]()
    
    public init(state: State, differ: @escaping Differ, reducer: @escaping Reducer) {
        self.state = state
        self.differ = differ
        self.reducer = reducer
    }

    public func dispatch(action: Action) {
        queue.async {
            self.reducer(&self.state, action)
            self.notifyAll(after: action)
        }
    }

    public func subscribe(observer: Observer<State>) {
        queue.async {
            self.observers.insert(observer)
            self.notify(observer)
        }
    }
}

private extension Store {
    func notifyAll(after action: Action) {
        let notified = observers.compactMap { notifyExact($0) ?? nil }
        printInfo(after: action, notified: notified)
        self.changed = []
    }
    
    func notifyExact(_ observer: Observer<State>) -> String? {
        if needToNotify(observer: observer) {
            notify(observer)
            return observer.id
        }
        
        return nil
    }

    func notify(_ observer: Observer<State>) {
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
    
    func needToNotify(observer: Observer<State>) -> Bool {
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

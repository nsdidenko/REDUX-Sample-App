import Foundation
import Helpers

public final class Store<State, Action> {
    public typealias Differ = (State, State) -> [String]
    public typealias Reducer = (inout State, Action) -> Void
    
    public private(set) var state: State {
        didSet { changed.append(contentsOf: differ(state, oldValue)) }
    }
    
    private var observers = Set<Observer<State>>() {
        didSet { printInfo(oldValue: oldValue) }
    }
    
    private var changed = [String]()
    
    private let queue = DispatchQueue(label: "Store queue", qos: .userInitiated)
    private let differ: Differ
    private let timeline: Timeline
    private let reducer: Reducer
    
    public init(state: State, differ: @escaping Differ, timeline: Timeline = RealTimeline(), reducer: @escaping Reducer) {
        self.state = state
        self.differ = differ
        self.timeline = timeline
        self.reducer = reducer
    }
    
    public func subscribe(observer: Observer<State>) {
        timeline.schedule(on: queue) {
            self.observers.insert(observer)
            self.notify(observer)
        }
    }
    
    public func dispatch(_ actions: Action...) {
        timeline.schedule(on: queue) {
            actions.forEach { action in
                self.reducer(&self.state, action)
            }

            self.notifyAll(after: actions)
        }
    }
}

private extension Store {
    func notifyAll(after actions: [Action]) {
        let notified = observers.compactMap { notifyExact($0) ?? nil }
        printInfo(after: actions, notified: notified)
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
        
        timeline.schedule(on: observer.queue) {
            let status = observer.process(state)

            if case .dead = status {
                self.timeline.schedule(on: self.queue) {
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
    
    func diff(arr: inout [String], set: Set<String>) {
        for item in set {
            if let index = arr.firstIndex(of: item) {
                arr.remove(at: index)
            }
        }
    }
}

// MARK: - Print info

private extension Store {
    func printInfo(after actions: [Action], notified: [String]) {
        #if DEBUG
        
        let header = """
        ---------------[Store]---------------|
        
        """
        
        let actions = actions.map { String(describing: $0).without("Core.") }
        var leaks = notified
        let notifiedSet = Set(notified)
        
        diff(arr: &leaks, set: notifiedSet)
        
        let info = """
        
        - Actions(\(actions.count))   : \(actions)
        - Changed(\(changed.count))   : \(changed)
        - Observers(\(observers.count))
        - Notified(\(notified.count)) : \(notified)
        - Leaks(\(leaks.count)) : \(leaks)
        
        -------------------------------------|
        
        """.withoutBrackets
        
        print(header.appending(info))
        
        #endif
    }
    
    func printInfo(oldValue: Set<Observer<State>>) {
        #if DEBUG
        
        log("Store", level: .info, value: "Observers count: WAS: \(oldValue.count), BECOME: \(observers.count)")

        for oldObserver in oldValue where !observers.contains(oldObserver) {
            log("Store", level: .info, value: "Removed observer: \(oldObserver.id)")
        }

        for observer in observers where !oldValue.contains(observer) {
            log("Store", level: .info, value: "Added observer: \(observer.id)")
        }
        
        #endif
    }
}

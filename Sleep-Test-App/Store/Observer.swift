import Foundation

public class Observer<State>: Hashable {
    public static func == (lhs: Observer<State>, rhs: Observer<State>) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    public func hash(into hasher: inout Hasher) {
        ObjectIdentifier(self).hash(into: &hasher)
    }

    private let action: (State) -> Void

    public func perform(with value: State) {
        action(value)
    }

    public init(action: @escaping (State) -> Void) {
        self.action = action
    }
}

public extension Observer {
    func dispatched(on queue: DispatchQueue) -> Observer {
        Observer { value in
            queue.async {
                self.perform(with: value)
            }
        }
    }
}

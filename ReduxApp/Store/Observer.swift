import Foundation

public class Observer<State>: Hashable {
    public typealias Process = (State) -> Status

    public static func == (lhs: Observer<State>, rhs: Observer<State>) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    public func hash(into hasher: inout Hasher) {
        ObjectIdentifier(self).hash(into: &hasher)
    }

    public enum Status {
        case active
        case dead
    }

    let queue: DispatchQueue
    let process: Process

    public init(queue: DispatchQueue = .main, process: @escaping Process) {
        self.queue = queue
        self.process = process
    }
}

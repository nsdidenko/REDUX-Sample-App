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

    let id: String
    let queue: DispatchQueue
    let process: Process
    let ids: [String]

    public init(id: String, queue: DispatchQueue = .main, ids: String..., process: @escaping Process) {
        self.id = id
        self.queue = queue
        self.ids = ids
        self.process = process
    }
}

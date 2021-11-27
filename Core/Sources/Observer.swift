import Foundation

public class Observer: Hashable {
    public typealias Process = (AppState) -> Status

    public static func == (lhs: Observer, rhs: Observer) -> Bool {
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
    let ids: [String]

    public init(queue: DispatchQueue = .main, ids: [String], process: @escaping Process) {
        self.queue = queue
        self.ids = ids
        self.process = process
    }
}

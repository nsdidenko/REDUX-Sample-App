import Foundation

public protocol Timeline {
    var date: Date { get }

    func schedule(on queue: DispatchQueue, work: @escaping () -> Void)
}

public class RealTimeline: Timeline {
    public var date: Date { Date() }

    public init() {}

    public func schedule(on queue: DispatchQueue, work: @escaping () -> Void) {
        queue.async { work() }
    }
}

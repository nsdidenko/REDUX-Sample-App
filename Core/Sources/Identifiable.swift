
public protocol Identifiable {
    static var id: String { get }
}

public extension Identifiable {
    static var id: String {
        String(describing: type(of: self))
    }
}

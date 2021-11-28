
public protocol StateIdentifiable {
    static var id: String { get }
}

public extension StateIdentifiable {
    static var id: String {
        String(describing: type(of: self)).replacingOccurrences(of: ".Type", with: "")
    }
}

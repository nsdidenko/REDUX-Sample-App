
public struct User: Equatable {
    public var name: String

    public init(name: String = "") {
        self.name = name
    }

    public mutating func reduce(_ action: Action) {
        switch action {
        case let action as DidEnterName:
            name = action.name

        default:
            break
        }
    }
}

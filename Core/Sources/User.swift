
public struct User {
    public var name: String

    public init(name: String = "") {
        self.name = name
    }

    public mutating func reduce(_ action: Action) {
        switch action {
        case let action as SetUserName:
            name = action.name

        default:
            break
        }
    }

}

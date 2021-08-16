
public struct User: Equatable {
    public var name: Name

    public init(name: Name = .init(value: "")) {
        self.name = name
    }

    public mutating func reduce(_ action: Action) {
        name.reduce(action)
    }
}

public struct Name: Equatable {
    public private(set) var value: String

    public init(value: String = "") {
        self.value = value
    }

    public mutating func reduce(_ action: Action) {
        switch action {
        case let action as DidEnterName:
            self = action.name

        default:
            break
        }
    }
}


public struct NameInput: Equatable {
    public private(set) var maxLength: Int
    public private(set) var value: String

    public init(
        maxLength: Int = 10,
        value: String = ""
    ) {
        self.maxLength = maxLength
        self.value = value
    }

    public mutating func reduce(_ action: Action) {
        switch action {
        case let action as DidEditName:
            value = String(action.value.prefix(maxLength))

        default:
            break
        }
    }
}

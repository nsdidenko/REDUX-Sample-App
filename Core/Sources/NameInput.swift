import Foundation

public struct NameInput: Equatable {
    public enum Validity {
        case empty, valid, invalid
    }

    public private(set) var maxLength: Int
    public private(set) var value: String
    public private(set) var validity: Validity

    public init(
        maxLength: Int = 10,
        value: String = "",
        validity: Validity = .empty
    ) {
        self.maxLength = maxLength
        self.value = value
        self.validity = validity
    }

    public mutating func reduce(_ action: Action) {
        switch action {
        case let action as DidEditName:
            value = String(action.value.prefix(maxLength))

            validity = {
                if value.isEmpty {
                    return .empty
                } else if containsNumbers {
                    return .invalid
                } else {
                    return .valid
                }
            }()

        default:
            break
        }
    }

    private var containsNumbers: Bool {
        value.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
    }
}

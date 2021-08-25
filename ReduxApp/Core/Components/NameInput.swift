import Foundation

public struct NameInput: Equatable, Codable {
    public enum Validity: Int, Codable {
        case empty, valid, invalid
    }

    public private(set) var maxLength: Int = 10
    public private(set) var value: String = ""
    public private(set) var validity: Validity = .empty

    public init() {}

    mutating func reduce(_ action: Action) {
        switch action {
        case let action as NameInputValueChanged:
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

// MARK: - Actions

public struct NameInputValueChanged: Action {
    public let value: String

    public init(with value: String) {
        self.value = value
    }
}

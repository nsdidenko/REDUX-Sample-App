import Foundation

public struct User: Equatable {
    public struct Name: Equatable {
        private let id: UUID
        public let value: String

        public init(id: UUID = UUID(), _ value: String) {
            self.id = id
            self.value = value
        }
    }

    public var name: Name

    public init(name: Name = .init("")) {
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

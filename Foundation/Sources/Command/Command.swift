import Foundation

public final class CommandWith<T> {
    private let action: (T) -> Void

    public init(action: @escaping (T) -> Void) {
        self.action = action
    }

    public func perform(with value: T) {
        action(value)
    }

    /// Placeholder for do nothing command
    public static var nop: CommandWith { CommandWith { _ in } }
}

// MARK: - Hashable

extension CommandWith: Hashable {
    public static func == (left: CommandWith, right: CommandWith) -> Bool {
        ObjectIdentifier(left) == ObjectIdentifier(right)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

// MARK: - Codable

extension CommandWith: Codable {
    public convenience init(from decoder: Decoder) throws {
        self.init { _ in }
    }

    public func encode(to encoder: Encoder) throws {}
}

// MARK: - Command

public typealias Command = CommandWith<Void>

public extension CommandWith where T == Void {
    func perform() {
        perform(with: ())
    }
}

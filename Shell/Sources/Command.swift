import Foundation

public final class CommandWith<T> {
    private let id: String
    private let file: StaticString
    private let function: StaticString
    private let line: Int
    private let action: (T) -> Void

    public init(id: String = "unnamed", file: StaticString = #file, function: StaticString = #function, line: Int = #line, action: @escaping (T) -> Void) {
        self.id = id
        self.file = file
        self.function = function
        self.line = line
        self.action = action
    }

    public func perform(with value: T) {
        action(value)
    }

    /// Placeholder for do nothing command
    public static var nop: CommandWith { CommandWith(id: "nop") { _ in } }

    /// Support for Xcode quick look feature.
    @objc
    public func debugQuickLookObject() -> AnyObject? {
        """
            type: \(String(describing: type(of: self)))
            id: \(id)
            file: \(file)
            function: \(function)
            line: \(line)
            """ as NSString
    }
}

public extension CommandWith {
    // swiftlint:disable identifier_name
    func map<U>(transform: @escaping (U) -> T) -> CommandWith<U> {
        CommandWith<U> { u in self.perform(with: transform(u)) }
    }

    func then(_ another: CommandWith) -> CommandWith {
        CommandWith { value in
            self.perform(with: value)
            another.perform(with: value)
        }
    }

    func dispatched(on queue: DispatchQueue) -> CommandWith {
        CommandWith { value in
            queue.async {
                self.perform(with: value)
            }
        }
    }

    func bind(to value: T) -> Command {
        Command { self.perform(with: value) }
    }
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

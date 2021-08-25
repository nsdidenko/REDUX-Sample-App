
public struct User: Equatable, Codable {
    public enum Status: Int, Codable {
        case idle, loading, ready
        // TODO: - error
    }

    public private(set) var status = Status.idle
    public private(set) var name = ""

    public mutating func reduce(_ action: Action) {
        switch action {
        case is DidFinishLaunch:
            status = .loading

        case let action as DidLoadName:
            name = action.name
            status = .ready

        case let action as DidSetName:
            name = action.name

        case is DidStartEnterName:
            name = ""

        default:
            break
        }
    }

    public init() {}
}

// MARK: - Actions

public struct DidLoadName: Action {
    public let name: String

    public init(_ name: String) {
        self.name = name
    }
}

public struct DidSetName: Action {
    public let name: String

    public init(_ name: String) {
        self.name = name
    }
}
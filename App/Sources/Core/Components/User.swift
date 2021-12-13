
public struct User: Equatable, Codable, StateIdentifiable, AutoAppState {
    public private(set) var name = ""

    public mutating func reduce(_ action: Action) {
        on(action, DidLoadName.self) {
            name = $0.name
        }
        
        on(action, DidSetName.self) {
            name = $0.name
        }
        
        on(action, DidStartEnterName.self) {
            name = ""
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

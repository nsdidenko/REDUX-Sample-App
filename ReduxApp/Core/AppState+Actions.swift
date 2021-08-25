
public struct AppState: Codable {
    public private(set) var flow = Flow()
    public private(set) var remoteConfig = RemoteConfig()
    public private(set) var allPaywalls = AllPaywalls()
    public private(set) var nameInput = NameInput()
    public private(set) var user = User()

    public mutating func reduce(_ action: Action) {
        flow.reduce(action)
        remoteConfig.reduce(action)
        allPaywalls.reduce(action)
        nameInput.reduce(action)
        user.reduce(action)
    }

    public init() {}
}

// MARK: - Actions

public protocol Action: Codable {}

public struct DidFinishLaunch: Action { public init() {} }

public struct DidLoadRemoteConfig: Action { public init() {} }


public struct AppState: Codable {
    public private(set) var flow = Flow()
    public private(set) var remoteConfigState = RemoteConfigState()
    public private(set) var allPaywalls = AllPaywalls()
    public private(set) var paywallsLoadingStatus = PaywallsLoadingStatus()
    public private(set) var nameInput = NameInput()
    public private(set) var user = User()

    public mutating func reduce(_ action: Action) {
        flow.reduce(action)
        remoteConfigState.reduce(action)
        allPaywalls.reduce(action)
        paywallsLoadingStatus.reduce(action)
        nameInput.reduce(action)
        user.reduce(action)
    }

    public init() {}
}

// MARK: - Actions

public protocol Action: Codable {}

public struct DidFinishLaunch: Action { public init() {} }

public struct DidLoadRemoteConfig: Action {
    public let remoteConfig: RemoteConfig

    public init(remoteConfig: RemoteConfig) {
        self.remoteConfig = remoteConfig
    }
}

public struct DidLoadPaywalls: Action {
    public let paywalls: [Paywall]

    public init(paywalls: [Paywall]) {
        self.paywalls = paywalls
    }
}

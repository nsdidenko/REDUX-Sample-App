
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

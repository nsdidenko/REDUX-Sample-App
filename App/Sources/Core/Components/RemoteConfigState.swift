
public struct RemoteConfigState: Equatable, Codable, StateIdentifiable, AutoAppState {
    public private(set) var config: RemoteConfig?

    mutating func reduce(_ action: Action) {
        on(action, DidLoadRemoteConfig.self) {
            config = $0.remoteConfig
        }
    }

    public init() {}
}

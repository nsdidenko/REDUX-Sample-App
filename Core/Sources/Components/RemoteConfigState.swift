
public struct RemoteConfigState: Equatable, Codable, StateIdentifiable, AutoAppState {
    public private(set) var config: RemoteConfig?

    mutating func reduce(_ action: Action) {
        switch action {
        case let action as DidLoadRemoteConfig:
            config = action.remoteConfig

        default:
            break
        }
    }

    public init() {}
}

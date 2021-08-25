
public struct RemoteConfig: Equatable, Codable {
    public enum Status: Int, Codable {
        case idle, loading, ready
        // TODO: - error
    }

    public private(set) var status = Status.idle

    mutating func reduce(_ action: Action) {
        switch action {
        case is DidFinishLaunch:
            status = .loading

        case is DidLoadRemoteConfig:
            status = .ready

        default:
            break
        }
    }

    public init() {}
}

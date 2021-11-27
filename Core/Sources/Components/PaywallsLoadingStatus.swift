
public enum PaywallsLoadingStatus: Int, Equatable, Codable, Identifiable {
    case idle, loading, ready
    // TODO: - error

    mutating func reduce(_ action: Action) {
        switch action {
        case is DidFinishLaunch:
            self = .loading

        case is DidLoadPaywalls:
            self = .ready

        default:
            break
        }
    }

    public init() {
        self = .idle
    }
}

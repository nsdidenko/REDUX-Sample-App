
public enum PaywallsLoadingStatus: Equatable, Codable, StateIdentifiable, AutoAppState {
    case idle, loading, ready
    // TODO: - error

    mutating func reduce(_ action: Action) {
        on(action, DidFinishLaunch.self) {
            self = .loading
        }
        
        on(action, DidLoadPaywalls.self) {
            self = .ready
        }
    }

    public init() {
        self = .idle
    }
}

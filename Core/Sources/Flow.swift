
public enum Flow {
    case launching
    case splash
    case onboarding
    case home

    public init() {
        self = .launching
    }

    public mutating func reduce(_ action: Action) {
        switch action {
        case is Initial:
            self = .launching

        case is DidFinishLaunch:
            self = .splash

        case is StartOnboarding:
            self = .onboarding

        case is StartHome:
            self = .home

        default:
            break
        }
    }
}

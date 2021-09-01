
public struct Flow: Equatable, Codable {
    public private(set) var isLaunchCompleted = false
    public private(set) var isSplashCompleted = false
    public private(set) var isEnterNameCompleted = false
    public private(set) var isPaywallCompleted = false

    mutating func reduce(_ action: Action) {
        switch action {
        case is DidFinishLaunch:
            isLaunchCompleted = true

        case is DidLoadRemoteConfig:
            isSplashCompleted = true

        case is DidSetName:
            isEnterNameCompleted = true

        case is DidStartEnterName:
            isEnterNameCompleted = false

        case is DidPurchase:
            isPaywallCompleted = true

        default:
            break
        }
    }

    public init() {}
}

// MARK: - Actions

public struct DidStartEnterName: Action { public init() {} }

public struct DidPurchase: Action { public init() {} }

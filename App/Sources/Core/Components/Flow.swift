
public struct Flow: Equatable, Codable, StateIdentifiable, AutoAppState {
    public private(set) var isLaunchCompleted = false
    public private(set) var isSplashCompleted = false
    public private(set) var isEnterNameCompleted = false
    public private(set) var isPaywallCompleted = false

    mutating func reduce(_ action: Action) {
        on(action, DidFinishLaunch.self) {
            isLaunchCompleted = true
        }
        
        on(action, DidLoadRemoteConfig.self) {
            isSplashCompleted = true
        }
        
        on(action, DidSetName.self) {
            isEnterNameCompleted = true
        }
        
        on(action, DidStartEnterName.self) {
            isEnterNameCompleted = false
        }
        
        on(action, DidPurchase.self) {
            isPaywallCompleted = true
        }
    }

    public init() {}
}

// MARK: - Actions

public struct DidStartEnterName: Action { public init() {} }

public struct DidPurchase: Action { public init() {} }

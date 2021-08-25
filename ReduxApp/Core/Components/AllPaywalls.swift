
public struct AllPaywalls: Equatable, Codable {
    public enum Status: Int, Codable {
        case idle, loading, ready
        // TODO: - error
    }

    public private(set) var status = Status.idle
    public private(set) var paywalls = [Paywall]()
    public private(set) var chosen = [String: Int]()

    mutating func reduce(_ action: Action) {
        switch action {
        case is DidFinishLaunch:
            status = .loading

        case let action as DidLoadPaywalls where !action.paywalls.isEmpty:
            status = .ready
            paywalls = action.paywalls

            for paywall in action.paywalls {
                chosen[paywall.id] = 0
            }

        case let action as DidSelectInAppProduct:
            chosen[action.paywallId] = action.index

        default:
            break
        }
    }

    public init() {}
}

// MARK: - Actions

public struct DidLoadPaywalls: Action {
    public let paywalls: [Paywall]

    public init(paywalls: [Paywall]) {
        self.paywalls = paywalls
    }
}

public struct DidSelectInAppProduct: Action {
    public let index: Int
    public let paywallId: String

    public init(at index: Int, in paywallId: String) {
        self.index = index
        self.paywallId = paywallId
    }
}


public struct AllPaywalls: Equatable, Codable, StateIdentifiable, AutoAppState {
    public private(set) var paywalls = [Paywall]()

    mutating func reduce(_ action: Action) {
        on(action, DidLoadPaywalls.self) {
            precondition(!$0.paywalls.isEmpty)

            paywalls = $0.paywalls
        }
        
        on(action, DidSelectInAppProduct.self) { action in
            precondition(!paywalls.filter { $0.id == action.paywallId }.isEmpty)

            paywalls
                .firstIndex(where: { $0.id == action.paywallId })
                .map { paywalls[$0].chosen = action.index }
        }
    }

    public init() {}
}

// MARK: - Actions

public struct DidSelectInAppProduct: Action {
    public let index: Int
    public let paywallId: String

    public init(at index: Int, in paywallId: String) {
        self.index = index
        self.paywallId = paywallId
    }
}

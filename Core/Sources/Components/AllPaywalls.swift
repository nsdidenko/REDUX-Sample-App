
public struct AllPaywalls: Equatable, Codable {
    public private(set) var paywalls = [Paywall]()

    mutating func reduce(_ action: Action) {
        switch action {
        case let action as DidLoadPaywalls:
            precondition(!action.paywalls.isEmpty)

            paywalls = action.paywalls

        case let action as DidSelectInAppProduct:
            precondition(!paywalls.filter { $0.id == action.paywallId }.isEmpty)

            paywalls
                .firstIndex(where: { $0.id == action.paywallId })
                .map { paywalls[$0].chosen = action.index }

        default:
            break
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

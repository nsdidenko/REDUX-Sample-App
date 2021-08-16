import Foundation

public enum Paywall: Equatable {
    case loading
    case ready(AllSubscriptions)

    public init() {
        self = .loading
    }

    public mutating func reduce(_ action: Action) {
        switch action {
        case let action as DidLoadSubscriptions:
            let first = action.subscriptions.first!
            let rest = Array<Subscription>(action.subscriptions.dropFirst())
            self = .ready(.init(head: [], selected: first, rest: rest))

        default:
            break
        }

        if case let .ready(all) = self {
            var all = all
            all.reduce(action)
            self = .ready(all)
        }
    }
}

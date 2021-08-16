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

public struct AllSubscriptions: Equatable {
    public let head: [Subscription]
    public let selected: Subscription
    public let rest: [Subscription]

    public init(head: [Subscription] = [], selected: Subscription = .init(), rest: [Subscription] = []) {
        self.head = head
        self.selected = selected
        self.rest = rest
    }

    public mutating func reduce(_ action: Action) {
        switch action {
        case let action as DidSelectPaywallOption:
            let all = all()
            var head = [Subscription]()
            var selected: Subscription!
            var rest = [Subscription]()
            if let index = all.firstIndex(of: action.subscription) {
                for (i, s) in all.enumerated() {
                    if i < index {
                        head.append(s)
                    } else if i == index {
                        selected = s
                    } else {
                        rest.append(s)
                    }
                }
            }

            self = .init(head: head, selected: selected, rest: rest)

        default:
            break
        }
    }

    public func all() -> [Subscription] {
        var result = head
        result.append(selected)
        result.append(contentsOf: rest)
        return result
    }
}

public struct Subscription: Equatable {
    public let id: String
    public let price: Decimal
    public let locale: Locale

    public init(id: String = "", price: Decimal = 0, locale: Locale = .init(identifier: "")) {
        self.id = id
        self.price = price
        self.locale = locale
    }
}

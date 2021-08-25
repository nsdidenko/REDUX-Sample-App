import Foundation

public final class PaywallsLoaderOperator {
    public typealias Store = ReduxApp.Store<AppState, Action>
    public typealias Observer = ReduxApp.Observer<AppState>
    public typealias Load = (@escaping ([Paywall]) -> Void) -> Void

    private let store: Store
    private let load: Load

    public init(store: Store, load: @escaping Load) {
        self.store = store
        self.load = load
    }

    private var status: AllPaywalls.Status?

    public func process(_ state: AllPaywalls) -> Observer.Status {
        guard state.status != status else { return .active }
        status = state.status

        if status == .loading {
            load() { paywalls in
                self.store.dispatch(action: DidLoadPaywalls(paywalls: paywalls))
            }
            return .dead
        } else {
            return .active
        }
    }

    public var asObserver: Observer {
        .init { self.process($0.allPaywalls) }
    }
}

public enum PaywallsLoader {
    public static func run(completion: @escaping ([Paywall]) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            completion([
                .init(
                    id: "paywall 1",
                    inAppProducts: [
                        .init(id: "s1", price: .init(value: 9.99, locale: .init(identifier: "en_US"))),
                        .init(id: "s2", price: .init(value: 16.99, locale: .init(identifier: "en_US"))),
                        .init(id: "s3", price: .init(value: 49.99, locale: .init(identifier: "en_US")))
                    ]),

                .init(
                    id: "paywall 2",
                    inAppProducts: [
                        .init(id: "s3", price: .init(value: 49.99, locale: .init(identifier: "en_US"))),
                        .init(id: "s2", price: .init(value: 16.99, locale: .init(identifier: "en_US"))),
                        .init(id: "s1", price: .init(value: 9.99, locale: .init(identifier: "en_US")))
                    ])
            ])
        }
    }
}

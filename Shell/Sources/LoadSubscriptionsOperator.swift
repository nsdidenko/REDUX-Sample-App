import Foundation
import ReduxStore
import Core

public class LoadSubscriptionsOperator {
    public typealias Load = (@escaping ([Subscription]) -> Void) -> Void

    private let store: Store<AppState, Action>
    private let load: Load

    public init(store: Store<AppState, Action>, load: @escaping Load) {
        self.store = store
        self.load = load
    }

    private var currentCheckPoint: Flow.CheckPoint?

    public func process(_ state: Flow.CheckPoint) {
        guard state == .launching, state != currentCheckPoint else { return }
        currentCheckPoint = state

        load { [weak self] subscriptions in
            self?.store.dispatch(action: DidLoadSubscriptions(subscriptions: subscriptions))
        }
    }
}

public extension Store where State == Core.AppState, Action == Core.Action {
    func subscribeLoadSubscriptionsOperator(load: @escaping LoadSubscriptionsOperator.Load) {
        let op = LoadSubscriptionsOperator(store: self, load: load)
        subscribe(observer: .init { op.process($0.flow.currentCheckPoint) }.dispatched(on: .main))
    }
}

public enum SubscriptionsLoader {
    public static func run(completion: @escaping ([Subscription]) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 4) {
            completion([
                .init(id: "s1", price: 9.99, locale: .init(identifier: "en_US")),
                .init(id: "s2", price: 16.99, locale: .init(identifier: "en_US")),
                .init(id: "s3", price: 49.99, locale: .init(identifier: "en_US"))
            ])
        }
    }
}

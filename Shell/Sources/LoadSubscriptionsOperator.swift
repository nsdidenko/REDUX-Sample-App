import Foundation
import ReduxStore
import Core

public class LoadSubscriptionsOperator {
    private let store: Store<AppState, Action>

    public init(store: Store<AppState, Action>) {
        self.store = store
    }

    private var currentCheckPoint: Flow.CheckPoint?

    public func process(_ state: Flow.CheckPoint) {
        guard state == .launching, state != currentCheckPoint else { return }
        currentCheckPoint = state

        DispatchQueue.global().asyncAfter(deadline: .now() + 4) {
            self.store.dispatch(action: DidLoadSubscriptions(subscriptions: [
                .init(id: "s1", price: 9.99, locale: .init(identifier: "en_US")),
                .init(id: "s2", price: 16.99, locale: .init(identifier: "en_US")),
                .init(id: "s3", price: 49.99, locale: .init(identifier: "en_US"))
            ]))
        }
    }
}

public extension Store where State == Core.AppState, Action == Core.Action {
    func subscribeLoadSubscriptionsOperator() {
        let op = LoadSubscriptionsOperator(store: self)
        subscribe(observer: .init { op.process($0.flow.currentCheckPoint) }.dispatched(on: .main))
    }
}

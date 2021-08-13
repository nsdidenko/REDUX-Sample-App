import Core
import ReduxStore
import Foundation

public class FlowLoadOperator {
    private let store: Store<AppState, Action>
    private let skipOnboarding: () -> Bool

    public init(store: Store<AppState, Action>, skipOnboarding: @escaping () -> Bool) {
        self.store = store
        self.skipOnboarding = skipOnboarding
    }

    private var currentCheckPoint: Flow.CheckPoint?

    public func process(_ state: Flow.CheckPoint) {
        guard state == .launching, state != currentCheckPoint else { return }
        currentCheckPoint = state

        store.dispatch(action: SkipOnboarding(flag: skipOnboarding()))
    }
}

public extension Store where State == Core.AppState, Action == Core.Action {
    func subscribeFlowLoadOperator(skipOnboarding: @escaping () -> Bool) {
        let op = FlowLoadOperator(store: self, skipOnboarding: skipOnboarding)
        subscribe(observer: .init { op.process($0.flow.currentCheckPoint) }.dispatched(on: .main) )
    }
}

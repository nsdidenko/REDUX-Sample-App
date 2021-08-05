import Foundation
import Core
import ReduxStore

public struct LastActionConsolePrintOperator {
    public func process(_ state: AppState) {
        let action = state.lastSomeAction.action
        Console("Action -> \(action)")
    }

    public init() {}
}

public extension Store where State == Core.AppState, Action == Core.Action {
    func subscribeLastActionConsolePrintOperator() {
        let op = LastActionConsolePrintOperator()
        subscribe(observer: .init(action: op.process))
    }
}

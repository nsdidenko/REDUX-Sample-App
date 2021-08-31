import UIKit

public enum EnterNameUIComposer: Storyboarded {
    public static func compose(store: Store<AppState, Action>) -> EnterNameViewController {
        let vc = storyboarded(.onboarding, ofType: EnterNameViewController.self)

        let uiOperator = EnterNameUIOperator(
            store: store,
            render: .init { vc.props = $0 })

        store.subscribe(observer: uiOperator.asObserver)

        return vc
    }
}

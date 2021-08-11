import UIKit
import Core
import ReduxStore

public enum EnterNameUIComposer: Storyboarded {
    public static func compose(store: Store<AppState, Action>) -> EnterNameViewController {
        let vc = storyboarded(.onboarding, ofType: EnterNameViewController.self)

        vc.props = EnterNameViewController.Props(
            title: "Enter name",
            action: .init { store.dispatch(action: DidEnterName(.init($0))) })

        return vc
    }
}

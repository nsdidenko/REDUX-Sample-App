import UIKit
import Core
import ReduxStore

public enum EnterNameUIComposer: Storyboarded {
    static func compose(store: Store<AppState, Action>) -> EnterNameViewController {
        let vc = storyboarded(.onboarding, ofType: EnterNameViewController.self)

        vc.props = EnterNameViewController.Props(
            title: "Enter name",
            action: .init { store.dispatch(action: DidEnterName($0)) })

        return vc
    }
}

public enum HomeUIComposer: Storyboarded {
    static func compose(store: Store<AppState, Action>) -> HomeViewController {
        let vc = storyboarded(.home, ofType: HomeViewController.self)
        return vc
    }
}

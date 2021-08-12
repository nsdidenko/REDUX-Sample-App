import UIKit
import Core
import ReduxStore
import Shell

public enum EnterNameUIComposer: Storyboarded {
    public static func compose(store: Store<AppState, Action>) -> EnterNameViewController {
        let vc = storyboarded(.onboarding, ofType: EnterNameViewController.self)

        let presenter = EnterNamePresenter(
            store: store,
            render: .init { vc.props = $0 })

        store.subscribe(observer: .init(action: { appState in
            presenter.process(appState.nameInput)
        }).dispatched(on: .main))

        return vc
    }
}

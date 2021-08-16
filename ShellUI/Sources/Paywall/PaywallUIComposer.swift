import UIKit
import Core
import ReduxStore
import Shell

public enum PaywallUIComposer: Storyboarded {
    public static func compose(store: Store<AppState, Action>, completion: @escaping () -> Void = {}) -> PaywallViewController {
        let vc = storyboarded(.paywall, ofType: PaywallViewController.self)

        let presenter = PaywallPresenter(
            store: store,
            render: .init { vc.props = $0 })

        store.subscribe(observer: .init(action: { appState in
            presenter.process(appState.paywall)
            completion()
        }).dispatched(on: .main))

        return vc
    }
}

import UIKit

public enum EnterNameUIComposer: Storyboarded {
    public static func compose(store: Store<AppState, Action>) -> EnterNameViewController {
        let vc = storyboarded(.onboarding, ofType: EnterNameViewController.self)

        let userDefaultsNameCacheOperator = UserDefaultsNameCacheOperator(store: store)
        store.subscribe(observer: userDefaultsNameCacheOperator.asObserver)

        let presenter = EnterNamePresenter(
            store: store,
            render: .init { vc.props = $0 })

        store.subscribe(observer: presenter.asObserver)

        return vc
    }
}

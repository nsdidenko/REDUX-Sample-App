import UIKit
import Core
import ReduxStore
import Shell

public struct EnterNamePresenter {
    public typealias Props = EnterNameViewController.Props

    let store: Store<AppState, Action>
    let render: CommandWith<Props>

    public init(
        store: Store<AppState, Action>,
        render: CommandWith<EnterNameViewController.Props>
    ) {
        self.store = store
        self.render = render
    }

    public func process(_ state: NameInput) {
        let props = Props(
            title: "Enter name",
            header: "Please enter the name you would like to use:",
            field: .init(
                text: state.value,
                placeholder: "Enter name",
                updated: .init { store.dispatch(action: DidEditName(with: $0)) }),
            button: .init(
                title: "Next",
                state: state.value.isEmpty
                    ? .inactive
                    : .active(.init {
                        store.dispatch(action: DidEnterName(.init(value: state.value)))
                    })))

        render.perform(with: props)
    }
}

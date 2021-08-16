import UIKit
import Core
import ReduxStore
import Shell

public struct EnterNamePresenter {
    public typealias Store = ReduxStore.Store<AppState, Action>
    public typealias Props = EnterNameViewController.Props

    let store: Store
    let render: CommandWith<Props>

    public init(store: Store, render: CommandWith<Props>) {
        self.store = store
        self.render = render
    }

    public func process(_ state: NameInput) {
        let props = Props(
            title: "Please enter the name you would like to use:",
            invalidCaption: .init(
                title: "The name must not contain numbers.",
                state: map(state.validity)),
            field: .init(
                text: state.value,
                placeholder: "Enter name",
                updated: .init { store.dispatch(action: DidEditName(with: $0)) }),
            button: .init(title: "Next", state: map(state)))

        render.perform(with: props)
    }

    // MARK: - Helpers

    private func map(_ input: NameInput) -> NextButton.Props.State {
        switch input.validity {
        case .empty, .invalid:
            return .inactive

        case .valid:
            return .active(.init {
                store.dispatch(action: DidEnterName(.init(value: input.value)))
            })
        }
    }

    private func map(_ validity: NameInput.Validity) -> Props.InvalidCaption.State {
        switch validity {
        case .invalid: return .shown
        case .empty, .valid: return .hidden
        }
    }
}

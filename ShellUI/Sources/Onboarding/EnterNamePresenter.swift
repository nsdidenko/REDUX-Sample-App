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

    private func map(_ input: NameInput) -> EnterNameNextButton.Props.State {
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

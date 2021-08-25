import UIKit

public struct EnterNamePresenter {
    public typealias Props = EnterNameViewController.Props

    let store: Store<AppState, Action>
    let render: CommandWith<Props>

    public init(store: Store<AppState, Action>, render: CommandWith<Props>) {
        self.store = store
        self.render = render
    }

    public var asObserver: Observer<AppState> {
        .init {
            self.process($0.nameInput)
            return .active
        }
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
                updated: .init { store.dispatch(action: NameInputValueChanged(with: $0)) }),
            button: .init(title: "Next", state: map(state)),
            didAppear: .init { store.dispatch(action: DidStartEnterName()) })

        render.perform(with: props)
    }

    // MARK: - Helpers

    private func map(_ input: NameInput) -> NextButton.Props.State {
        switch input.validity {
        case .empty, .invalid:
            return .inactive

        case .valid:
            return .active(.init {
                store.dispatch(action: DidSetName(input.value))
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

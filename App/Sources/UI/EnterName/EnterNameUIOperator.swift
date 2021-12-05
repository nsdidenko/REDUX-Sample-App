import UIKit
import Core
import Command
import Helpers

public struct EnterNameUIOperator {
    public typealias Props = EnterNameViewController.Props

    let store: Store
    let render: CommandWith<Props>

    public init(store: Store, render: CommandWith<Props>) {
        self.store = store
        self.render = render
    }

    public var asObserver: Observer {
        .init(id: typename(self), ids: NameInput.id) {
            self.process($0)
            return .active
        }
    }

    // MARK: - Private

    private func process(_ state: AppState) {
        let nameInput = state.nameInput
        
        let props = Props(
            invalidCaption: .init(state: map(nameInput.validity)),
            field: .init(
                text: nameInput.value,
                updated: .init { store.dispatch(action: NameInputValueChanged(with: $0)) }),
            button: .init(title: "Next", state: map(nameInput)),
            didAppear: .init { store.dispatch(action: DidStartEnterName()) })

        render.perform(with: props)
    }

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

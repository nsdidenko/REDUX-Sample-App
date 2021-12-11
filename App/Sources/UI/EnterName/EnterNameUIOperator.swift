import UIKit
import Core
import Command
import Helpers

public struct EnterNameUIOperator {
    public typealias Props = EnterNameViewController.Props

    let store: Store

    var idsToObserve: [String] {
        [NameInput.id]
    }

    func process(_ state: AppState) -> Props {
        let nameInput = state.nameInput
        
        return Props(
            invalidCaption: .init(state: map(nameInput.validity)),
            field: .init(
                text: nameInput.value,
                updated: .init { store.dispatch(NameInputValueChanged(with: $0)) }),
            button: .init(title: "Next", state: map(nameInput)),
            didAppear: .init { store.dispatch(DidStartEnterName()) })
    }
    
    // MARK: - Private

    private func map(_ input: NameInput) -> NextButton.Props.State {
        switch input.validity {
        case .empty, .invalid:
            return .inactive

        case .valid:
            return .active(.init {
                store.dispatch(DidSetName(input.value))
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

import Foundation
import XCTest
import Core

final class NameInputTests: XCTestCase {
    func test_didEditName() {
        var state = NameInput()

        state.reduce(DidEditName(with: "B"))
        state.reduce(DidEditName(with: "Bo"))

        assertEqual(expected: .init(value: "Bo", validity: .valid), actual: state)
    }

    func test_maxLength() {
        var state = NameInput(maxLength: 4, value: "", validity: .empty)

        state.reduce(DidEditName(with: "B"))
        state.reduce(DidEditName(with: "Bo"))
        state.reduce(DidEditName(with: "Bob"))
        state.reduce(DidEditName(with: "Bobb"))
        state.reduce(DidEditName(with: "Bobby"))

        assertEqual(expected: .init(maxLength: 4, value: "Bobb", validity: .valid), actual: state)
    }

    func test_invalid() {
        var state = NameInput(value: "", validity: .empty)

        state.reduce(DidEditName(with: "B"))
        state.reduce(DidEditName(with: "Bo"))
        state.reduce(DidEditName(with: "Bo1"))

        assertEqual(expected: .init(value: "Bo1", validity: .invalid), actual: state)
    }
}

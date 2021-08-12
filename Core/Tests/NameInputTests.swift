import Foundation
import XCTest
import Core

final class NameInputTests: XCTestCase {
    func test_didEditName() {
        var state = NameInput(maxLength: 4, value: "")

        state.reduce(DidEditName(with: "B"))
        state.reduce(DidEditName(with: "Bo"))

        assertEqual(expected: .init(maxLength: 4, value: "Bo"), actual: state)
    }

    func test_maxLength() {
        var state = NameInput(maxLength: 4, value: "")

        state.reduce(DidEditName(with: "B"))
        state.reduce(DidEditName(with: "Bo"))
        state.reduce(DidEditName(with: "Bob"))
        state.reduce(DidEditName(with: "Bobb"))
        state.reduce(DidEditName(with: "Bobby"))

        assertEqual(expected: .init(maxLength: 4, value: "Bobb"), actual: state)
    }
}

import Foundation
import XCTest
import Core

final class NameTests: XCTestCase {
    func test_didEnterName() {
        var state = Name()
        let name = Name(id: UUID(), maxLength: 4, value: "Bob")

        state.reduce(DidEnterName(name))

        assertEqual(expected: name, actual: state)
    }
}

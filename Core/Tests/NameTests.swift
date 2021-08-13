import Foundation
import XCTest
import Core

final class NameTests: XCTestCase {
    func test_didEnterName() {
        var state = Name()
        let name = Name(value: "Bob")

        state.reduce(DidEnterName(name))

        assertEqual(expected: name, actual: state)
    }
}

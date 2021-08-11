import Foundation
import XCTest
import Core

final class UserTests: XCTestCase {
    func test_didEnterName() {
        var state = User()
        let name = User.Name(id: UUID(), "Bob")

        state.reduce(DidEnterName(name))

        assertEqual(expected: .init(name: name), actual: state)
    }
}

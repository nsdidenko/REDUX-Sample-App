import Foundation
import XCTest
import Core

final class UserTests: XCTestCase {
    func test_init() {
        let state = User()
        assertEqual(expected: .init(name: ""), actual: state)
    }

    func test_didEnterName() {
        var state = User()
        state.reduce(DidEnterName("Bob"))
        assertEqual(expected: .init(name: "Bob"), actual: state)
    }
}

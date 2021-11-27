import UIKit

var greeting = "Hello, playground"

protocol StateId {
    static var id: String { get }
}

extension StateId {
    static var id: String {
        String(describing: type(of: self))
    }
}

struct SubstateOne: StateId {
    var count = 0
}

struct SubstateTwo: StateId {
    var count = 0
}

protocol Operator {
    var ids: Set<String> { get }
}

struct SubstateOneOperator: Operator {
    var ids: Set<String> { [SubstateOne.id, SubstateTwo.id] }
}

let op = SubstateOneOperator()
op.ids

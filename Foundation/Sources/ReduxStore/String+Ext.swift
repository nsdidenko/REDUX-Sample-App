import Foundation

extension String {
    var withoutBrackets: String {
        replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
    }
    
    func without(_ prefix: String) -> String {
        replacingOccurrences(of: "Core.", with: "")
    }
}

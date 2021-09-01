import Foundation

enum UserNameLoader {
    static func load(completion: @escaping (String) -> Void) {
        if let name = UserDefaults.standard.string(forKey: "user_name") {
            completion(name)
        }
    }
}

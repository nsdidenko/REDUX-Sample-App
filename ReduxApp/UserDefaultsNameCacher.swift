import Foundation

enum UserDefaultsNameCacher {
    static func cache(_ name: String) {
        UserDefaults.standard.setValue(name, forKey: "user_name")
    }

    static func remove() {
        UserDefaults.standard.removeObject(forKey: "user_name")
    }
}

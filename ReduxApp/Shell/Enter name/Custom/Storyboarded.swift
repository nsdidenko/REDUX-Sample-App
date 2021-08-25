import UIKit

public protocol Storyboarded {}

public enum StoryboardName: String {
    case onboarding = "EnterName"
    case paywall = "Paywall"
}

public extension Storyboarded {
    static func storyboarded<T: UIViewController>(_ sb: StoryboardName, ofType type: T.Type) -> T {
        UIStoryboard.init(name: sb.rawValue, bundle: Bundle.main)
            .instantiateViewController(withIdentifier: "\(T.self)") as! T
    }

    func storyboarded<T: UIViewController>(_ sb: StoryboardName, ofType type: T.Type) -> T {
        UIStoryboard.init(name: sb.rawValue, bundle: Bundle.main)
            .instantiateViewController(withIdentifier: "\(T.self)") as! T
    }
}
import UIKit

public protocol Storyboarded {}

public enum StoryboardName: String {
    case splash = "Splash"
    case onboarding = "Onboarding"
    case home = "Home"
}

public extension Storyboarded {
    static func storyboarded<T: UIViewController>(_ sb: StoryboardName, ofType type: T.Type) -> T {
        UIStoryboard.init(name: sb.rawValue, bundle: Bundle.module)
            .instantiateViewController(withIdentifier: "\(T.self)") as! T
    }

    func storyboarded<T: UIViewController>(_ sb: StoryboardName, ofType type: T.Type) -> T {
        UIStoryboard.init(name: sb.rawValue, bundle: Bundle.module)
            .instantiateViewController(withIdentifier: "\(T.self)") as! T
    }
}

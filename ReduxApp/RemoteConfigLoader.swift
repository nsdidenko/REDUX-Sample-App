import Foundation
import Core

enum RemoteConfigLoader {
    static func load(completion: @escaping (RemoteConfig) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            completion(.init(requestReviewEnabled: true))
        }
    }
}

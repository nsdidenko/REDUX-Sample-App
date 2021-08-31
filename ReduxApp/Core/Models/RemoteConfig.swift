
public struct RemoteConfig: Equatable, Codable {
    public let requestReviewEnabled: Bool

    public init(requestReviewEnabled: Bool) {
        self.requestReviewEnabled = requestReviewEnabled
    }
}

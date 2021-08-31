
public struct Paywall: Equatable, Codable {
    public let id: String
    public let inAppProducts: [InAppProduct]
    public var chosen: Int = 0

    public init(id: String, inAppProducts: [InAppProduct]) {
        self.id = id
        self.inAppProducts = inAppProducts
    }
}

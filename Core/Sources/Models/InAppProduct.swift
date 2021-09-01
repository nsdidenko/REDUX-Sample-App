import Foundation

public struct InAppProduct: Equatable, Codable {
    public let id: String
    public let price: Price

    public init(id: String, price: Price) {
        self.id = id
        self.price = price
    }
}

public struct Price: Equatable, Codable {
    public let value: Decimal
    public let locale: Locale

    public init(value: Decimal, locale: Locale) {
        self.value = value
        self.locale = locale
    }
}

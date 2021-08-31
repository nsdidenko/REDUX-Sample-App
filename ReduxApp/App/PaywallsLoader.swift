import Foundation

enum PaywallsLoader {
    static func load(completion: @escaping ([Paywall]) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            completion([
                .init(
                    id: "paywall 1",
                    inAppProducts: [
                        .init(id: "s1", price: .init(value: 9.99, locale: .init(identifier: "en_US"))),
                        .init(id: "s2", price: .init(value: 16.99, locale: .init(identifier: "en_US"))),
                        .init(id: "s3", price: .init(value: 49.99, locale: .init(identifier: "en_US")))
                    ]),

                .init(
                    id: "paywall 2",
                    inAppProducts: [
                        .init(id: "s3", price: .init(value: 49.99, locale: .init(identifier: "en_US"))),
                        .init(id: "s2", price: .init(value: 16.99, locale: .init(identifier: "en_US"))),
                        .init(id: "s1", price: .init(value: 9.99, locale: .init(identifier: "en_US")))
                    ])
            ])
        }
    }
}

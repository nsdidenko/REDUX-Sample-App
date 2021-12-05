
public protocol AnalyticsProviding {
    func track(_ event: String)
}

struct AnalyticsProvider: AnalyticsProviding {
    func track(_ event: String) {
        print("AnalyticsProvider tracked event: \(event)")
    }
}

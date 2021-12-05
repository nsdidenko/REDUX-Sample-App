import Injected

public extension InjectedValues {
    var analytics: AnalyticsProviding {
        get { Self[AnalyticsProviderKey.self] }
        set { Self[AnalyticsProviderKey.self] = newValue }
    }
}

private struct AnalyticsProviderKey: InjectionKey {
    static var currentValue: AnalyticsProviding = AnalyticsProvider()
}

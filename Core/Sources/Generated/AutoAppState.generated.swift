// Generated using Sourcery 1.6.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable all

public struct AppState {
    public private(set) var allPaywalls = AllPaywalls()
    public private(set) var flow = Flow()
    public private(set) var nameInput = NameInput()
    public private(set) var paywallsLoadingStatus = PaywallsLoadingStatus()
    public private(set) var remoteConfigState = RemoteConfigState()
    public private(set) var user = User()

    public mutating func reduce(_ action: Action) {
        allPaywalls.reduce(action)
        flow.reduce(action)
        nameInput.reduce(action)
        paywallsLoadingStatus.reduce(action)
        remoteConfigState.reduce(action)
        user.reduce(action)
    }

    public init() {}
}
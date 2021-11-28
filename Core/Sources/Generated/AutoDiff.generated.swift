// Generated using Sourcery 1.6.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable all

public extension AppState {
    func diff(from previous: Self) -> [String] {
        var ids = [String]()

        if allPaywalls != previous.allPaywalls {
            ids.append(AllPaywalls.id)
        }

        if flow != previous.flow {
            ids.append(Flow.id)
        }

        if nameInput != previous.nameInput {
            ids.append(NameInput.id)
        }

        if paywallsLoadingStatus != previous.paywallsLoadingStatus {
            ids.append(PaywallsLoadingStatus.id)
        }

        if remoteConfigState != previous.remoteConfigState {
            ids.append(RemoteConfigState.id)
        }

        if user != previous.user {
            ids.append(User.id)
        }

        return ids
    }
}
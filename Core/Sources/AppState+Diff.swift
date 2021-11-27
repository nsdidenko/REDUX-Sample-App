
// Кодогенерация
extension AppState {
    func diff(from previous: AppState) -> [String] {
        var ids = [String]()
        
        if flow != previous.flow {
            ids.append(Flow.id)
        }
        
        if remoteConfigState != previous.remoteConfigState {
            ids.append(RemoteConfigState.id)
        }
        
        if allPaywalls != previous.allPaywalls {
            ids.append(AllPaywalls.id)
        }
        
        if paywallsLoadingStatus != previous.paywallsLoadingStatus {
            ids.append(PaywallsLoadingStatus.id)
        }
        
        if nameInput != previous.nameInput {
            ids.append(NameInput.id)
        }
        
        if user != previous.user {
            ids.append(User.id)
        }
        
        return ids
    }
}

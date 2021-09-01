import Core
import ReduxStore

public typealias Store = ReduxStore.Store<AppState, Action>
public typealias Observer = ReduxStore.Observer<AppState>

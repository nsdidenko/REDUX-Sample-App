import ReduxStore

let store = Store(initial: AppState(), reducer: { $0.reduce($1) })
dumpWithBreak(store.state)

store.dispatch(action: DidFinishLaunch())
dumpWithBreak(store.state)

store.dispatch(action: SetUserName(name: "Bob"))
dumpWithBreak(store.state)













// MARK: - Helpers

func dumpWithBreak(_ value: Any) {
    dump(value)
    print("\n------------------------------------------------------\n")
}

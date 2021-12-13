
protocol AutoAppState {}

func on<T: Action>(_ action: Action, _ type: T.Type, run: () -> Void) {
    if action is T {
        run()
    }
}

func on<T: Action>(_ action: Action, _ type: T.Type, run: (T) -> Void) {
    if let action = action as? T {
        run(action)
    }
}

func on<T: Action>(_ action: Action, _ type: T.Type, where condition: Bool, run: (T) -> Void) {
    if let action = action as? T, condition {
        run(action)
    }
}

func on<T: Action>(_ action: Action, _ type: T.Type, where condition: Bool, run: () -> Void) {
    if action is T, condition {
        run()
    }
}

func on<T: Action>(_ action: Action, _ type: T.Type, where condition: (T) -> Bool, run: (T) -> Void) {
    if let action = action as? T, condition(action) {
        run(action)
    }
}

func on<T: Action>(_ action: Action, _ type: T.Type, where condition: (T) -> Bool, run: () -> Void) {
    if let action = action as? T, condition(action) {
        run()
    }
}

func on<T: Action>(_ action: Action, _ type: T.Type, where condition: () -> Bool, run: (T) -> Void) {
    if let action = action as? T, condition() {
        run(action)
    }
}

func on<T: Action>(_ action: Action, _ type: T.Type, where condition: () -> Bool, run: () -> Void) {
    if action is T, condition() {
        run()
    }
}

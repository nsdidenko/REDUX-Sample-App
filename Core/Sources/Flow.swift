
public struct Flow: Equatable {
    public enum CheckPoint {
        case launching
        case splash
        case onboarding
        case home
    }

    public private(set) var checkPoints: [CheckPoint]
    public private(set) var currentCheckPoint: CheckPoint

    public init(
        checkPoints: [CheckPoint] = [],
        currentCheckPoint: CheckPoint = .launching
    ) {
        self.checkPoints = checkPoints
        self.currentCheckPoint = currentCheckPoint
    }

    public mutating func reduce(_ action: Action) {
        switch action {
        case is Initial:
            currentCheckPoint = .launching
            checkPoints = [ currentCheckPoint ]

        case let action as SkipOnboarding:
            checkPoints = action.flag
                ? [ .launching, .splash, .home ]
                : [ .launching, .splash, .onboarding, .home ]

        case is DidFinishLaunch:
            currentCheckPoint = .splash

        case is DidLoadRemoteConfig:
            nextCheckPoint().map { currentCheckPoint = $0 }

        case is DidPurchase:
            nextCheckPoint().map { currentCheckPoint = $0 }

        default:
            break
        }
    }

    private func nextCheckPoint() -> CheckPoint? {
        if let index = checkPoints.firstIndex(of: currentCheckPoint) {
            let nextIndex = index + 1

            if nextIndex <= checkPoints.count - 1 {
                return checkPoints[nextIndex]
            }
        }

        assertionFailure()
        return nil
    }
}

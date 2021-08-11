import Foundation
import XCTest
import Core

final class FlowTests: XCTestCase {
    func test_init() {
        let state = Flow()

        assertEqual(expected: .init(checkPoints: [], currentCheckPoint: .launching),
                    actual: state)
    }

    func test_initial() {
        var state = Flow()

        state.reduce(Initial())

        assertEqual(expected: .init(checkPoints: [ .launching ], currentCheckPoint: .launching),
                    actual: state)
    }

    func test_skipOnboardingTrue() {
        var state = Flow()

        state.reduce(SkipOnboarding(flag: true))

        assertEqual(expected: .init(checkPoints: [ .launching, .splash, .home ], currentCheckPoint: .launching),
                    actual: state)
    }

    func test_skipOnboardingFalse() {
        var state = Flow()

        state.reduce(SkipOnboarding(flag: false))

        assertEqual(expected: .init(checkPoints: [ .launching, .splash, .onboarding, .home ], currentCheckPoint: .launching),
                    actual: state)
    }

    func test_didFinishLaunch() {
        let checkPoints: [Flow.CheckPoint] = [ .launching, .splash, .home ]
        var state = Flow(checkPoints: checkPoints, currentCheckPoint: .launching)

        state.reduce(DidFinishLaunch())

        assertEqual(expected: .init(checkPoints: checkPoints, currentCheckPoint: .splash),
                    actual: state)
    }

    func test_didLoadRemoteConfig_beginUsingApp() {
        let checkPoints: [Flow.CheckPoint] = [ .launching, .splash, .home ]
        var state = Flow(checkPoints: checkPoints, currentCheckPoint: .splash)

        state.reduce(DidLoadRemoteConfig())

        assertEqual(expected: .init(checkPoints: checkPoints, currentCheckPoint: .home),
                    actual: state)
    }

    func test_didLoadRemoteConfig_continueUsingApp() {
        let checkPoints: [Flow.CheckPoint] = [ .launching, .splash, .onboarding, .home ]
        var state = Flow(checkPoints: checkPoints, currentCheckPoint: .splash)

        state.reduce(DidLoadRemoteConfig())

        assertEqual(expected: .init(checkPoints: checkPoints, currentCheckPoint: .onboarding),
                    actual: state)
    }

    func test_didPurchase() {
        let checkPoints: [Flow.CheckPoint] = [ .launching, .splash, .onboarding, .home ]
        var state = Flow(checkPoints: checkPoints, currentCheckPoint: .onboarding)

        state.reduce(DidPurchase())

        assertEqual(expected: .init(checkPoints: checkPoints, currentCheckPoint: .home),
                    actual: state)
    }
}

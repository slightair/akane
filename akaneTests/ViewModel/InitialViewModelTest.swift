import XCTest
import RxSwift
import RxTest

class InitialViewModelTest: XCTestCase {
    func testInitialViewModel() {
        let scheduler = TestScheduler(initialClock: 0)

        let loginTaps = scheduler.createHotObservable([
            next(200, ()),
        ])

        let fetchUserTriger = scheduler.createHotObservable([
            next(100, ()),
            next(500, ()),
        ])

        let credentialSubject = scheduler.createHotObservable([
            next(400, MockRedditAuthorization.testCredential),
            completed(410),
        ])

        let userInfoSubject = scheduler.createHotObservable([
            next(600, MockRedditService.testUser),
            completed(600),
        ])

        let expectedNeedsLoginEvents = [
            next(100, true),
            next(500, false),
        ]

        let expectedNeedsAuthorizeEvents = [
            next(200, MockRedditAuthorization.testURL)
        ]

        let expectedRetrievedCredentialEvents = [
            next(400, MockRedditAuthorization.testCredential),
            completed(410)
        ]

        let expectedLoggedInEvents = [
            next(100, false),
            next(600, true),
        ]

        let mockRedditService = MockRedditService(userInfoSubject: userInfoSubject.asSingle())
        let mockRedditAuthorization = MockRedditAuthorization(credentialSubject: credentialSubject.asObservable())

        let viewModel = InitialViewModel(
            input: (
                loginTaps: loginTaps.asObservable(),
                fetchUserTrigger: fetchUserTriger.asObservable()
            ),
            dependency: (
                redditService: mockRedditService,
                redditAuthorization: mockRedditAuthorization
            )
        )

        let recordedNeedsLogin = scheduler.record(source: viewModel.needsLogin)
        let recordedNeedsAuthorize = scheduler.record(source: viewModel.needsAuthorize)
        let recordedRetrievedCredential = scheduler.record(source: viewModel.retrievedCredential)
        let recordedLoggedIn = scheduler.record(source: viewModel.loggedIn)

        scheduler.start()

        XCTAssertEqual(recordedNeedsLogin.events, expectedNeedsLoginEvents)
        XCTAssertEqual(recordedNeedsAuthorize.events, expectedNeedsAuthorizeEvents)
        XCTAssertEqual(recordedRetrievedCredential.events, expectedRetrievedCredentialEvents)
        XCTAssertEqual(recordedLoggedIn.events, expectedLoggedInEvents)
    }
}

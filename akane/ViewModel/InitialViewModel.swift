import Foundation
import RxSwift

final class InitialViewModel {
    let needsLogin: Observable<Bool>
    let needsAuthorize: Observable<URL>
    let retrievedCredential: Observable<RedditCredential>
    let loggedIn: Observable<Bool>

    init(
        input: (
            loginTaps: Observable<Void>,
            fetchUserTrigger: Observable<Void>
        ),
        dependency: (
            redditService: RedditService,
            redditAuthorization: RedditAuthorization
        )) {

        let userUpdated = input.fetchUserTrigger
            .flatMapLatest { dependency.redditService.fetchUserInfo() }
            .map { _ in }

        let statusUpdated = Observable.of(input.fetchUserTrigger, userUpdated)
            .merge()
            .shareReplay(1)

        needsLogin = statusUpdated
            .map { !dependency.redditService.hasRefreshToken }
            .distinctUntilChanged()
            .shareReplay(1)

        needsAuthorize = input.loginTaps
            .map { dependency.redditAuthorization.authorizeURL }
            .shareReplay(1)

        retrievedCredential = dependency.redditAuthorization.credential
            .do(onNext: { dependency.redditService.storeCredential($0) })
            .shareReplay(1)

        loggedIn = statusUpdated
            .map { dependency.redditService.hasUser }
            .distinctUntilChanged()
            .shareReplay(1)
    }
}

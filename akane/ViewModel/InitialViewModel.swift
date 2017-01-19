import Foundation
import RxSwift

final class InitialViewModel {
    let needsLogin: Observable<Bool>
    let retrievedCredential: Observable<Void>
    let loggedIn: Observable<Bool>

    init(
        fetchUserTrigger: Observable<Void>,
        dependency: (
            redditService: RedditService,
            redditAuthorization: RedditAuthorization
        )) {

        let userUpdated = fetchUserTrigger.flatMapLatest {
            dependency.redditService.fetchUserInfo()
        }.map { _ in }

        let statusUpdated = Observable.of(fetchUserTrigger, userUpdated)
            .merge()
            .shareReplay(1)

        needsLogin = statusUpdated.map {
            !dependency.redditService.hasRefreshToken
        }.distinctUntilChanged()

        retrievedCredential = dependency.redditAuthorization.credentials
            .do(onNext: { credential in
                dependency.redditService.storeCredential(credential)
            })
            .map { _ in }
            .shareReplay(1)

        loggedIn = statusUpdated.map {
            dependency.redditService.hasUser
        }.distinctUntilChanged()
    }
}

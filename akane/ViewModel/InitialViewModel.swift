import Foundation
import RxSwift

final class InitialViewModel {
    let needsLogin: Observable<Bool>
    let loggedIn: Observable<Bool>

    init(
        input: (
            requestInitialize: Observable<Void>,
            loginTaps: Observable<Void>
        ),
        dependency: (
            redditService: RedditService,
            redditAuthorization: RedditAuthorization
        )) {

        let fetchUserInfo = input.requestInitialize.flatMapLatest { () -> Observable<RedditUser> in
            let service = dependency.redditService
            if service.hasRefreshToken {
                return service.fetchUserInfo()
            }
            return Observable.empty()
        }.map { _ in }

        let trialAuthorization = input.loginTaps.flatMapLatest {
            dependency.redditAuthorization.rx.authorize()
        }.flatMapLatest {
            dependency.redditService.fetchUserInfo(credential: $0)
        }.map { _ in }

        let statusUpdate = Observable.of(input.requestInitialize, input.loginTaps, fetchUserInfo, trialAuthorization)
            .merge()
            .shareReplay(1)

        needsLogin = statusUpdate.map {
            !dependency.redditService.hasRefreshToken
        }.distinctUntilChanged()

        loggedIn = statusUpdate.map {
            dependency.redditService.hasUser
        }.distinctUntilChanged()
    }
}

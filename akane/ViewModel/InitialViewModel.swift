import Foundation
import RxSwift
import RxCocoa

final class InitialViewModel {
    let needsLogin: Driver<Bool>

    init(
        input: (
            requestLoginStatus: Observable<Void>,
            loginTaps: Observable<Void>
        ),
        dependency: (
            redditService: RedditService,
            redditAuthorization: RedditAuthorization
        )) {

        let trialAuthorize = input.loginTaps.flatMapLatest {
            dependency.redditAuthorization.rx.authorize()
        }.flatMapLatest {
            dependency.redditService.rx.login(credential: $0)
        }.map { _ in }

        let loginStatus = Observable.of(input.requestLoginStatus, input.loginTaps, trialAuthorize)
            .merge()
            .map { _ in dependency.redditService.isLogin }

        needsLogin = loginStatus.map { !$0 }.asDriver(onErrorJustReturn: true).distinctUntilChanged()
    }
}

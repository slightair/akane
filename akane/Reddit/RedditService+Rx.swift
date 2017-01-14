import Foundation
import RxSwift

extension RedditService: ReactiveCompatible {}

extension Reactive where Base: RedditService {
    func login(accessToken: RedditAccessToken) -> Observable<RedditUser> {
        return Observable.create { [weak base] observer in
            base?.login(accessToken: accessToken) { result in
                switch result {
                case .success(let user):
                    observer.onNext(user)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}

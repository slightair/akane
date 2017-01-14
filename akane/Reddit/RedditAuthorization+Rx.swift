import Foundation
import RxSwift

extension RedditAuthorization: ReactiveCompatible {}

extension Reactive where Base: RedditAuthorization {
    func authorize() -> Observable<RedditAccessToken> {
        return Observable.create { [weak base] observer in
            base?.authorize { result in
                switch result {
                case .success(let accessToken):
                    observer.onNext(accessToken)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}

import Foundation
import RxSwift
import APIKit

extension Session: ReactiveCompatible {}

extension Reactive where Base: Session {
    func response<T: Request>(_ request: T, refreshAccessTokenWhenExpired: Bool = true, service: RedditService = RedditDefaultService.shared) -> Single<T.Response> {
        return Single.create { [weak base] observer in
            let task = base?.send(request) { result in
                switch result {
                case .success(let response):
                    observer(.success(response))
                case .failure(let error):
                    observer(.error(error))
                }
            }

            return Disposables.create {
                task?.cancel()
            }
        }.retryWhen { (errors: Observable<Error>) in
            return errors.flatMapWithIndex { error, retryCount -> Single<RedditCredential> in
                if refreshAccessTokenWhenExpired, case SessionTaskError.responseError(ResponseError.unacceptableStatusCode(401)) = error, retryCount < 1 {
                    return service.refreshAccessToken()
                }
                return .error(error)
            }
        }
    }
}

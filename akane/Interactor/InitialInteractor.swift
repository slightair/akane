import Foundation
import RxSwift

enum RedditLoginStatus {
    case needsAuthorize(url: URL)
    case loggedIn
}

struct InitialInteractor: InitialInteractorProtocol {
    let service: RedditService
    let authorization: RedditAuthorization

    func checkLoginStatus() -> Single<RedditLoginStatus> {
        return .just(.loggedIn)
    }
}

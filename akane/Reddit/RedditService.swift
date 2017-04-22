import Foundation
import RxSwift

enum RedditServiceError: Error {
    case refreshTokenNotFound
}

protocol RedditService {
    var hasRefreshToken: Bool { get }
    var hasUser: Bool { get }

    func fetchUserInfo() -> Single<RedditUser>
    func refreshAccessToken() -> Single<RedditCredential>
    func storeCredential(_ credential: RedditCredential)
}

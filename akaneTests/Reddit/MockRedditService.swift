import Foundation
import RxSwift

class MockRedditService: RedditService {
    static let testUser = RedditUser(name: "test")

    private(set) var hasRefreshToken = false
    private(set) var hasUser = false

    let userInfoSubject: Single<RedditUser>
    func fetchUserInfo() -> Single<RedditUser> {
        if !hasRefreshToken {
            return .error(RedditServiceError.refreshTokenNotFound)
        }
        hasUser = true
        return userInfoSubject
    }

    func refreshAccessToken() -> Single<RedditCredential> {
        let credential = MockRedditAuthorization.testCredential
        storeCredential(credential)
        return .just(credential)
    }

    func storeCredential(_ credential: RedditCredential) {
        hasRefreshToken = true
    }

    init(userInfoSubject: Single<RedditUser>) {
        self.userInfoSubject = userInfoSubject
    }
}

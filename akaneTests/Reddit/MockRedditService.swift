import Foundation
import RxSwift

class MockRedditService: RedditService {
    static let testUser = RedditUser(name: "test")

    private(set) var hasRefreshToken = false
    private(set) var hasUser = false

    let userInfoSubject: Observable<RedditUser>
    func fetchUserInfo() -> Observable<RedditUser> {
        if !hasRefreshToken {
            return Observable.empty()
        }
        hasUser = true
        return userInfoSubject
    }

    func refreshAccessToken() -> Observable<RedditCredential> {
        return Observable.empty()
    }

    func storeCredential(_ credential: RedditCredential) {
        hasRefreshToken = true
    }

    init(userInfoSubject: Observable<RedditUser>) {
        self.userInfoSubject = userInfoSubject
    }
}

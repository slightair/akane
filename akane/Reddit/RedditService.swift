import Foundation
import RxSwift

protocol RedditService {
    var hasRefreshToken: Bool { get }
    var hasUser: Bool { get }

    func fetchUserInfo() -> Observable<RedditUser>
    func refreshAccessToken() -> Observable<RedditCredential>
    func storeCredential(_ credential: RedditCredential)
}

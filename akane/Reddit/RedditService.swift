import Foundation
import APIKit
import Result

class RedditService {
    static let shared = RedditService()

    var isLogin: Bool {
        return currentUser != nil
    }

    var currentUser: RedditUser?

    func login(accessToken: RedditAccessToken, completion: ((Result<RedditUser, SessionTaskError>) -> Void)) {
        let user = RedditUser()
        currentUser = user

        completion(.success(user))
    }
}

import Foundation

class RedditService {
    static let shared = RedditService()

    var isLogin: Bool {
        return currentUser != nil
    }

    var currentUser: RedditUser?
}

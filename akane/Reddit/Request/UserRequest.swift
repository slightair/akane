import Foundation
import APIKit

extension RedditAPI {
    struct UserRequest: RedditAPIRequest {
        typealias Response = RedditUser

        let method: HTTPMethod = .get
        let path: String = "/api/v1/me"
    }
}

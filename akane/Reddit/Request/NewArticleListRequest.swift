import Foundation
import APIKit

extension RedditAPI {
    struct NewArticleListRequest: RedditAPIRequest, ListingRequest {
        typealias Response = ListingResponse

        let method: HTTPMethod = .get
        let path: String = "/new"
        let requestKind: ListingRequestKind

        var queryParameters: [String: Any]? {
            var parameters: [String: Any] = [
                "limit": 5,
            ]

            switch requestKind {
            case .before(let name):
                parameters["before"] = name
            case .after(let name):
                parameters["after"] = name
            default:
                break
            }

            return parameters
        }
    }
}

import Foundation
import APIKit

extension RedditAPI {
    struct HotArticleListRequest: RedditAPIRequest, ListingRequest {
        typealias Response = ListingResponse

        let method: HTTPMethod = .get
        let path: String = "/hot"
        let requestKind: ListingRequestKind = .refresh

        var queryParameters: [String: Any]? {
            return [
                "limit": 30,
            ]
        }
    }
}

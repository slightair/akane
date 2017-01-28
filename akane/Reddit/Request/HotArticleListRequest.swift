import Foundation
import APIKit

extension RedditAPI {
    struct HotArticleListRequest: RedditAPIRequest, PaginationRequest {
        typealias Response = ListingResponse

        let method: HTTPMethod = .get
        let path: String = "/hot"
        let page: Int

        init(page: Int = 1) {
            self.page = page
        }
    }
}

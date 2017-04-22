import Foundation
import APIKit
import RxSwift

struct HotArticleListClient: ListingClient {
    func loadArticles(requestKind: ListingRequestKind) -> Single<ListingResponse> {
        let request = RedditAPI.HotArticleListRequest()
        return Session.shared.rx.response(request)
    }
}

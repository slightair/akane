import Foundation
import APIKit
import RxSwift

struct NewArticleListClient: ListingClient {
    func loadArticles(requestKind: ListingRequestKind) -> Single<ListingResponse> {
        let request = RedditAPI.NewArticleListRequest(requestKind: requestKind)
        return Session.shared.rx.response(request)
    }
}

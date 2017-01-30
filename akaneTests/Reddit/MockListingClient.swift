import Foundation
import RxSwift

struct MockListingClient: ListingClient {
    let responses: [ListingRequestKind: ListingResponse]

    func loadArticles(requestKind: ListingRequestKind) -> Observable<ListingResponse> {
        guard let response = responses[requestKind] else {
            return Observable.empty()
        }
        return Observable.just(response)
    }
}

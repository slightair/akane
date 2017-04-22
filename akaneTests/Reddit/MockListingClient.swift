import Foundation
import RxSwift

struct MockListingClient: ListingClient {
    enum MockListingClientError: Error {
        case mockResponseNotFound
    }

    let responses: [ListingRequestKind: ListingResponse]

    func loadArticles(requestKind: ListingRequestKind) -> Single<ListingResponse> {
        guard let response = responses[requestKind] else {
            return .error(MockListingClientError.mockResponseNotFound)
        }
        return .just(response)
    }
}

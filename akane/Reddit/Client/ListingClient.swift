import Foundation
import RxSwift

protocol ListingClient {
    func loadArticles(requestKind: ListingRequestKind) -> Single<ListingResponse>
}

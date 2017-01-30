import Foundation
import RxSwift

protocol ListingClient {
    func loadArticles(requestKind: ListingRequestKind) -> Observable<ListingResponse>
}

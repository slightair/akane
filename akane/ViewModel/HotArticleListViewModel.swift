import Foundation
import APIKit
import RxSwift

class HotArticleListViewModel {
    let articles: Observable<[Article]>

    init(
        refreshTrigger: Observable<Void>,
        client: ListingClient) {

        articles = refreshTrigger
            .flatMapLatest { _ -> Observable<ListingResponse> in
                client.loadArticles(requestKind: .refresh)
            }
            .map { $0.elements }
            .startWith([])
            .shareReplay(1)
    }
}

import Foundation
import APIKit
import RxSwift

class NewArticleListViewModel {
    enum TriggerType {
        case refresh, before, after
    }

    var articles: Observable<[Article]> = Observable.empty()
    var firstArticleName: String?
    var lastArticleName: String?

    init(
        input: (
            refreshTrigger: Observable<Void>,
            loadBeforeTrigger: Observable<Void>,
            loadAfterTrigger: Observable<Void>
        ),
        client: ListingClient) {

        let requestTrigger: Observable<TriggerType> = Observable
            .of(
                input.refreshTrigger.map { .refresh },
                input.loadBeforeTrigger.map { .before },
                input.loadAfterTrigger.map { .after }
            )
            .merge()

        articles = requestTrigger
            .flatMapLatest { type -> Single<ListingResponse> in
                let requestKind: ListingRequestKind
                if type == .before, let firstArticleName = self.firstArticleName {
                    requestKind = .before(firstArticleName)
                } else if type == .after, let lastArticleName = self.lastArticleName {
                    requestKind = .after(lastArticleName)
                } else {
                    requestKind = .refresh
                }
                return client.loadArticles(requestKind: requestKind)
            }
            .scan([]) { articles, response in
                switch response.requestKind {
                case .refresh:
                    return response.elements
                case .before:
                    return response.elements + articles
                case .after:
                    return articles + response.elements
                }
            }
            .do(onNext: { articles in
                self.firstArticleName = articles.first?.name
                self.lastArticleName = articles.last?.name
            })
            .startWith([])
            .shareReplay(1)
    }
}

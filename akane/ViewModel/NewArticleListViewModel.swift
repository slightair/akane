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
        session: Session = Session.shared) {

        let requestTrigger: Observable<TriggerType> = Observable
            .of(
                input.refreshTrigger.map { .refresh },
                input.loadBeforeTrigger.map { .before },
                input.loadAfterTrigger.map { .after }
            )
            .merge()

        articles = requestTrigger
            .flatMapLatest { type -> Observable<ListingResponse> in
                let requestKind: ListingRequestKind
                if type == .before, let firstArticleName = self.firstArticleName {
                    requestKind = .before(firstArticleName)
                } else if type == .after, let lastArticleName = self.lastArticleName {
                    requestKind = .after(lastArticleName)
                } else {
                    requestKind = .refresh
                }

                let request = RedditAPI.NewArticleListRequest(requestKind: requestKind)
                return session.rx.response(request)
            }
            .scan([]) { memo, response in
                switch response.requestKind {
                case .refresh:
                    return response.elements
                case .before:
                    return response.elements + memo
                case .after:
                    return memo + response.elements
                }
            }
            .do(onNext: { articles in
                self.firstArticleName = articles.first?.name
                self.lastArticleName = articles.last?.name
            })
            .startWith([])
    }
}

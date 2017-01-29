import Foundation
import APIKit
import RxSwift

class HotArticleListViewModel {
    let articles: Observable<[Article]>

    init(
        refreshTrigger: Observable<Void>,
        session: Session = Session.shared) {

        articles = refreshTrigger
            .flatMapLatest { _ -> Observable<ListingResponse> in
                let request = RedditAPI.HotArticleListRequest()
                return session.rx.response(request)
            }
            .map { $0.elements }
            .startWith([])
            .shareReplay(1)
    }
}

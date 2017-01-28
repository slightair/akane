import Foundation
import APIKit
import RxSwift

class HotArticleListViewModel {
    let articles: Observable<[Article]>

    init(session: Session = Session.shared) {
        let request = RedditAPI.HotArticleListRequest()
        articles = session.rx
            .response(request)
            .map { $0.elements }
    }
}

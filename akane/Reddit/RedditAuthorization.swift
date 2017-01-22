import Foundation
import RxSwift

protocol RedditAuthorization {
    var credential: Observable<RedditCredential> { get }
    var authorizeURL: URL { get }
    func handle(url: URL)
}

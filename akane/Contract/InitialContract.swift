import Foundation
import RxSwift
import RxCocoa

protocol InitialViewProtocol: class {
    var checkLoginStatusTrigger: Observable<Void> { get }
}

protocol InitialInteractorProtocol {
    func checkLoginStatus() -> Single<RedditLoginStatus>
}

protocol InitialPresenterProtocol: class {
    // nothing
}

protocol InitialWireframeProtocol: class {
    weak var viewController: InitialViewController? { get set }
    func presentRedditAuthorizationView(url: URL)
    func presentHomeView()
}

import UIKit
import SafariServices
import RxSwift
import RxCocoa

class InitialViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!

    let disposeBag = DisposeBag()

    var currentWebViewController: SFSafariViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        let requestFetchUser = PublishSubject<Void>()
        let firstViewWillAppeared = rx.sentMessage(#selector(viewWillAppear)).take(1).map { _ in }
        let fetchUserTrigger = Observable.of(requestFetchUser, firstViewWillAppeared).merge()

        let viewModel = InitialViewModel(
            fetchUserTrigger: fetchUserTrigger,
            dependency: (
                redditService: RedditService.shared,
                redditAuthorization: RedditAuthorization.shared
            )
        )

        loginButton.rx.tap.asObservable()
            .map { RedditAuthorization.shared.authorizeURL }
            .subscribe(onNext: { url in
                self.presentRedditAuthorization()
            }).addDisposableTo(disposeBag)

        viewModel.retrievedCredential.subscribe(onNext: { credential in
            self.currentWebViewController?.dismiss(animated: true, completion: nil)
            requestFetchUser.onNext(())
        }).addDisposableTo(disposeBag)

        viewModel.needsLogin.map { !$0 }
            .bindTo(loginButton.rx.isHidden)
            .addDisposableTo(disposeBag)

        let firstViewDidAppeared = rx.sentMessage(#selector(viewDidAppear)).take(1)
        Observable.combineLatest(viewModel.loggedIn.filter { $0 }, firstViewDidAppeared) { _ in }
            .subscribe(onNext: {
                self.presentHomeView()
            }).addDisposableTo(disposeBag)
    }

    func presentRedditAuthorization() {
        let viewController = SFSafariViewController(url: RedditAuthorization.shared.authorizeURL)
        viewController.modalTransitionStyle = .crossDissolve
        self.currentWebViewController = viewController
        self.present(viewController, animated: true, completion: nil)
    }

    func presentHomeView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "Home")
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true, completion: nil)
    }
}

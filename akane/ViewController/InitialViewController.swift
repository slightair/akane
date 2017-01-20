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

        let fetchUserTrigger = PublishSubject<Void>()
        let viewModel = InitialViewModel(
            input: (
                loginTaps: loginButton.rx.tap.asObservable(),
                fetchUserTrigger: fetchUserTrigger
            ),
            dependency: (
                redditService: RedditService.shared,
                redditAuthorization: RedditAuthorization.shared
            )
        )

        rx.sentMessage(#selector(viewWillAppear))
            .take(1)
            .subscribe(onNext: { _ in
                fetchUserTrigger.onNext(())
            })
            .addDisposableTo(disposeBag)

        viewModel.needsLogin
            .map { !$0 }
            .bindTo(loginButton.rx.isHidden)
            .addDisposableTo(disposeBag)

        viewModel.needsAuthorize
            .subscribe(onNext: { url in
                self.presentRedditAuthorization(url: url)
            })
            .addDisposableTo(disposeBag)

        viewModel.retrievedCredential
            .subscribe(onNext: { _ in
                self.currentWebViewController?.dismiss(animated: true, completion: nil)
                fetchUserTrigger.onNext(())
            })
            .addDisposableTo(disposeBag)

        viewModel.loggedIn
            .filter { $0 }
            .subscribe(onNext: { _ in
                self.presentHomeView()
            })
            .addDisposableTo(disposeBag)
    }

    func presentRedditAuthorization(url: URL) {
        let viewController = SFSafariViewController(url: url)
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

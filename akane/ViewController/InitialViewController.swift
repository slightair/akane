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
                redditService: RedditDefaultService.shared,
                redditAuthorization: RedditDefaultAuthorization.shared
            )
        )

        rx.sentMessage(#selector(viewWillAppear))
            .take(1)
            .subscribe(onNext: { _ in
                fetchUserTrigger.onNext(())
            })
            .disposed(by: disposeBag)

        viewModel.needsLogin
            .map { !$0 }
            .bind(to: loginButton.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.needsAuthorize
            .subscribe(onNext: { url in
                self.presentRedditAuthorization(url: url)
            })
            .disposed(by: disposeBag)

        viewModel.retrievedCredential
            .subscribe(onNext: { _ in
                fetchUserTrigger.onNext(())
                self.currentWebViewController?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        viewModel.loggedIn
            .filter { $0 }
            .subscribe(onNext: { _ in
                self.presentHomeView()
            })
            .disposed(by: disposeBag)
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

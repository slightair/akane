import UIKit
import RxSwift
import RxCocoa

class InitialViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let requestInitialize = rx.sentMessage(#selector(viewWillAppear)).take(1).map { _ in }

        let viewModel = InitialViewModel(
            input: (
                requestInitialize: requestInitialize,
                loginTaps: loginButton.rx.tap.asObservable()
            ),
            dependency: (
                redditService: RedditService.shared,
                redditAuthorization: RedditAuthorization.shared
            )
        )

        let hideLoginButton = viewModel.needsLogin.map { !$0 }
            .asDriver(onErrorJustReturn: false)
        hideLoginButton.drive(loginButton.rx.isHidden)
            .addDisposableTo(disposeBag)

        let viewDidAppeared = rx.sentMessage(#selector(viewDidAppear)).take(1).map { _ in }

        let presentHomeView = Observable.combineLatest(viewModel.loggedIn.filter { $0 }, viewDidAppeared) { _ in }
            .asDriver(onErrorJustReturn: ())
        presentHomeView.drive(onNext: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Home")
            viewController.modalTransitionStyle = .crossDissolve
            self.present(viewController, animated: true, completion: nil)
        }).addDisposableTo(disposeBag)
    }
}

import UIKit
import RxSwift
import RxCocoa

class InitialViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let requestLoginStatus = rx.sentMessage(#selector(viewWillAppear)).map { _ in }

        let viewModel = InitialViewModel(
            input: (
                requestLoginStatus: requestLoginStatus,
                loginTaps: loginButton.rx.tap.asObservable()
            ),
            dependency: (
                redditService: RedditService.shared,
                redditAuthorization: RedditAuthorization.shared
            )
        )

        let hideLoginButton = viewModel.needsLogin.map { !$0 }
        hideLoginButton.drive(loginButton.rx.isHidden)
            .addDisposableTo(disposeBag)

        let presentHomeView = viewModel.needsLogin.filter { !$0 }.map { _ in }
        presentHomeView.drive(onNext: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Home")
            viewController.modalTransitionStyle = .crossDissolve
            self.present(viewController, animated: true, completion: nil)
        }).addDisposableTo(disposeBag)
    }
}

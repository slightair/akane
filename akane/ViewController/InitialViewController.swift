import UIKit

class InitialViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if RedditService.shared.isLogin {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Home")
            viewController.modalTransitionStyle = .crossDissolve
            present(viewController, animated: true, completion: nil)
        } else {
            RedditAuthorization.authorize(from: self) { error in
                print(error)
            }
        }
    }
}

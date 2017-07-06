import UIKit
import RxSwift
import RxCocoa

final class InitialViewController: UIViewController {
    private var presenter: InitialPresenterProtocol!

    fileprivate let checkLoginStatusTriggerSubject = PublishSubject<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func inject(presenter: InitialPresenterProtocol) {
        self.presenter = presenter
    }
}

extension InitialViewController: InitialViewProtocol {
    var checkLoginStatusTrigger: Observable<Void> {
        return checkLoginStatusTriggerSubject.asObservable()
    }
}

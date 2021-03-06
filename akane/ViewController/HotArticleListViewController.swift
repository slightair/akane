import UIKit
import RxSwift
import RxCocoa

class HotArticleListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let refreshTrigger = rx.sentMessage(#selector(viewWillAppear)).map { _ in }

        let viewModel = HotArticleListViewModel(refreshTrigger: refreshTrigger.asObservable(),
                                                client: HotArticleListClient())

        viewModel.articles
            .bind(to: tableView.rx.items(cellIdentifier: "ArticleListCell")) { _, article, cell in
                cell.textLabel?.text = article.title
            }
            .disposed(by: disposeBag)
    }
}

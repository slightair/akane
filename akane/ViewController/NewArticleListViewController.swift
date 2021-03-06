import UIKit
import RxSwift
import RxCocoa

class NewArticleListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl

        let refreshTrigger = rx.sentMessage(#selector(viewWillAppear)).map { _ in }
        let loadBeforeTrigger = refreshControl.rx.controlEvent(.valueChanged)
        let loadAfterTrigger = tableView.rx.reachedBottom

        let viewModel = NewArticleListViewModel(
            input: (
                refreshTrigger: refreshTrigger.asObservable(),
                loadBeforeTrigger: loadBeforeTrigger.asObservable(),
                loadAfterTrigger: loadAfterTrigger.asObservable()
            ),
            client: NewArticleListClient()
        )

        viewModel.articles
            .bind(to: tableView.rx.items(cellIdentifier: "ArticleListCell")) { _, article, cell in
                cell.textLabel?.text = article.title
            }
            .disposed(by: disposeBag)

        viewModel.articles
            .map { _ in false }
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
}

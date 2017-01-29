import UIKit
import RxSwift
import RxCocoa

class NewArticleListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let beforeButton = UIBarButtonItem(title: "before", style: .plain, target: nil, action: nil)
        let afterButton = UIBarButtonItem(title: "after", style: .plain, target: nil, action: nil)

        navigationItem.leftBarButtonItem = beforeButton
        navigationItem.rightBarButtonItem = afterButton

        let refreshTrigger = rx.sentMessage(#selector(viewWillAppear)).map { _ in }
        let loadBeforeTrigger = beforeButton.rx.tap
        let loadAfterTrigger = afterButton.rx.tap

        let viewModel = NewArticleListViewModel(
            input: (
                refreshTrigger: refreshTrigger.asObservable(),
                loadBeforeTrigger: loadBeforeTrigger.asObservable(),
                loadAfterTrigger: loadAfterTrigger.asObservable()
            )
        )

        viewModel.articles
            .bindTo(tableView.rx.items(cellIdentifier: "ArticleListCell")) { _, article, cell in
                cell.textLabel?.text = article.title
            }
            .addDisposableTo(disposeBag)
    }
}

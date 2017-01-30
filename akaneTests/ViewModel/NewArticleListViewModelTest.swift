import XCTest
import RxSwift
import RxTest

class NewArticleListViewModelTest: XCTestCase {
    func testInitialViewModel() {
        let scheduler = TestScheduler(initialClock: 0)

        let refreshTrigger = scheduler.createHotObservable([
            next(200, ()),
            next(500, ()),
        ])

        let loadBeforeTrigger = scheduler.createHotObservable([
            next(300, ()),
        ])

        let loadAfterTrigger = scheduler.createHotObservable([
            next(400, ()),
        ])

        typealias ArticleList = [Article]

        let expectedArticlesEvents = [
            next(0, EquatableArray([])),
            next(200, EquatableArray([
                Article(title: "0", name: "0"),
                Article(title: "1", name: "1"),
                Article(title: "2", name: "2"),
            ])),
            next(300, EquatableArray([
                Article(title: "-3", name: "-3"),
                Article(title: "-2", name: "-2"),
                Article(title: "-1", name: "-1"),
                Article(title: "0", name: "0"),
                Article(title: "1", name: "1"),
                Article(title: "2", name: "2"),
            ])),
            next(400, EquatableArray([
                Article(title: "-3", name: "-3"),
                Article(title: "-2", name: "-2"),
                Article(title: "-1", name: "-1"),
                Article(title: "0", name: "0"),
                Article(title: "1", name: "1"),
                Article(title: "2", name: "2"),
                Article(title: "3", name: "3"),
                Article(title: "4", name: "4"),
                Article(title: "5", name: "5"),
            ])),
            next(500, EquatableArray([
                Article(title: "0", name: "0"),
                Article(title: "1", name: "1"),
                Article(title: "2", name: "2"),
            ])),
        ]

        let mockClient = MockListingClient(responses: [
            .refresh: ListingResponse(elements: [
                Article(title: "0", name: "0"),
                Article(title: "1", name: "1"),
                Article(title: "2", name: "2"),
            ], requestKind: .refresh),
            .before("0"): ListingResponse(elements: [
                Article(title: "-3", name: "-3"),
                Article(title: "-2", name: "-2"),
                Article(title: "-1", name: "-1"),
            ], requestKind: .before("0")),
            .after("2"): ListingResponse(elements: [
                Article(title: "3", name: "3"),
                Article(title: "4", name: "4"),
                Article(title: "5", name: "5"),
            ], requestKind: .after("2")),
        ])

        let viewModel = NewArticleListViewModel(
            input: (
                refreshTrigger: refreshTrigger.asObservable(),
                loadBeforeTrigger: loadBeforeTrigger.asObservable(),
                loadAfterTrigger: loadAfterTrigger.asObservable()
            ),
            client: mockClient
        )

        let recordedArticles = scheduler.record(source: viewModel.articles.map { EquatableArray($0) })

        scheduler.start()

        XCTAssertEqual(recordedArticles.events, expectedArticlesEvents)
    }
}

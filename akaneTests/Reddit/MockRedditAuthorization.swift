import Foundation
import RxSwift

class MockRedditAuthorization: RedditAuthorization {
    static let testCredential = RedditCredential(accessToken: "accessToken",
                                                 tokenType: "tokenType",
                                                 expiresIn: 3600,
                                                 scope: [],
                                                 refreshToken: "refreshToken")
    static let testURL = URL(string: "https://example.com")!

    let credential: Observable<RedditCredential>
    var authorizeURL: URL = MockRedditAuthorization.testURL

    func handle(url: URL) {}

    init(credentialSubject: Observable<RedditCredential>) {
        self.credential = credentialSubject
    }
}

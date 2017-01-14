import Foundation
import SafariServices
import APIKit

class RedditAuthorization {
    enum AuthorizationError {
        case invalidCallbackURL(URL)
        case failedToRequest(String)
        case stateMismatch
        case failedToRetrieveRefreshToken(Error)
    }

    typealias CompletionBlock = ((AuthorizationError?) -> Void)
    private static let privateShared = RedditAuthorization(clientID: RedditServiceConfiguration.clientID,
                                                           redirectURI: "akane://oauth-callback",
                                                           scope: [
                                                            "read",
                                                           ])
    let clientID: String
    let redirectURI: String
    let scope: [String]
    var recentState: String?

    var currentWebViewController: UIViewController?
    var completionBlock: CompletionBlock?

    var authorizeURL: URL {
        let state = updateState()
        let scope = self.scope.joined(separator: " ")

        var urlComponents = URLComponents(string: "https://www.reddit.com/api/v1/authorize.compact")!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "state", value: state),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "duration", value: "permanent"),
            URLQueryItem(name: "scope", value: scope),
        ]
        return urlComponents.url!
    }

    init(clientID: String, redirectURI: String, scope: [String]) {
        self.clientID = clientID
        self.redirectURI = redirectURI
        self.scope = scope
    }

    private func updateState() -> String {
        let state = UUID().uuidString
        recentState = state

        return state
    }

    static func authorize(from viewController: UIViewController, completion: @escaping CompletionBlock) {
        privateShared.authorize(from: viewController, completion: completion)
    }

    static func handle(url: URL) {
        privateShared.handle(url: url)
    }

    func authorize(from viewController: UIViewController, completion: @escaping CompletionBlock) {
        completionBlock = completion

        let safariViewController = SFSafariViewController(url: authorizeURL)
        currentWebViewController = safariViewController

        viewController.present(safariViewController, animated: true, completion: nil)
    }

    func handle(url: URL) {
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        guard let queryItems = urlComponents.queryItems else {
            completionBlock?(.invalidCallbackURL(url))
            return
        }

        if let error = queryItems.first(where: { $0.name == "error" })?.value {
            completionBlock?(.failedToRequest(error))
            return
        }

        guard let state = queryItems.first(where: { $0.name == "state" })?.value, state == recentState else {
            completionBlock?(.stateMismatch)
            return
        }

        guard let code = queryItems.first(where: { $0.name == "code" })?.value else {
            completionBlock?(.invalidCallbackURL(url))
            return
        }

        let request = RedditAPI.AccessTokenRequest(clientID: clientID, code: code, redirectURI: redirectURI)
        Session.send(request) { result in
            switch result {
            case .success(let accessToken):
                print(accessToken)

                self.currentWebViewController?.dismiss(animated: true) {
                    self.completionBlock?(nil)
                }
            case .failure(let error):
                self.completionBlock?(.failedToRetrieveRefreshToken(error))
            }
        }
    }
}

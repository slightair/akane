import Foundation
import APIKit
import RxSwift

class RedditAuthorization {
    enum AuthorizationError: Error {
        case invalidCallbackURL(URL)
        case failedToRequest(String)
        case stateMismatch
        case failedToRetrieveRefreshToken(Error)
    }

    static let shared = RedditAuthorization(clientID: RedditServiceConfiguration.clientID,
                                            redirectURI: "akane://oauth-callback",
                                            scope: [
                                                "identity",
                                                "read",
                                            ])
    let clientID: String
    let redirectURI: String
    let scope: [String]
    var recentState: String?

    let credentials = PublishSubject<RedditCredential>()

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

    func handle(url: URL) {
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        guard let queryItems = urlComponents.queryItems else {
            credentials.onError(AuthorizationError.invalidCallbackURL(url))
            return
        }

        if let error = queryItems.first(where: { $0.name == "error" })?.value {
            credentials.onError(AuthorizationError.failedToRequest(error))
            return
        }

        guard let state = queryItems.first(where: { $0.name == "state" })?.value, state == recentState else {
            credentials.onError(AuthorizationError.stateMismatch)
            return
        }

        guard let code = queryItems.first(where: { $0.name == "code" })?.value else {
            credentials.onError(AuthorizationError.invalidCallbackURL(url))
            return
        }

        let request = RedditAPI.AccessTokenRequest(clientID: clientID, code: code, redirectURI: redirectURI)
        Session.send(request) { result in
            switch result {
            case .success(let credential):
                self.credentials.onNext(credential)
                self.credentials.onCompleted()
            case .failure(let error):
                self.credentials.onError(AuthorizationError.failedToRetrieveRefreshToken(error))
            }
        }
    }
}

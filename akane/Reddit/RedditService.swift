import Foundation
import APIKit
import RxSwift
import KeychainAccess

class RedditService {
    static let shared = RedditService()

    let clientID: String

    private var keychain: Keychain {
        let service = "\(Bundle.main.bundleIdentifier!).reddit"
        return Keychain(service: service)
    }

    var hasRefreshToken: Bool {
        return keychain["refreshToken"] != nil
    }

    var hasUser: Bool {
        return currentUser != nil
    }

    var accessToken: String? {
        return keychain["accessToken"]
    }

    private var refreshToken: String? {
        return keychain["refreshToken"]
    }

    private(set) var currentUser: RedditUser?

    init(clientID: String = RedditServiceConfiguration.clientID) {
        self.clientID = clientID
    }

    func fetchUserInfo(credential: RedditCredential) -> Observable<RedditUser> {
        storeCredential(credential)

        return fetchUserInfo()
    }

    func fetchUserInfo() -> Observable<RedditUser> {
        let request = RedditAPI.UserRequest()
        return Session.shared.rx
            .response(request)
            .retryWhen { (errors: Observable<Error>) in
                return errors.flatMapWithIndex { error, retryCount -> Observable<RedditCredential> in
                    if case SessionTaskError.responseError(ResponseError.unacceptableStatusCode(401)) = error, retryCount < 1 {
                        return self.refreshAccessToken()
                    }
                    return Observable.error(error)
                }
            }
            .do(onNext: { user in
                self.currentUser = user
            })
    }

    func refreshAccessToken() -> Observable<RedditCredential> {
        guard let refreshToken = refreshToken else {
            fatalError("refresh token not found")
        }

        let request = RedditAPI.AccessTokenRequest(clientID: clientID, refreshToken: refreshToken)
        return Session.shared.rx.response(request)
            .do(onNext: { credential in
                self.storeCredential(credential)
            })
    }

    private func storeCredential(_ credential: RedditCredential) {
        let keychain = self.keychain

        keychain["accessToken"] = credential.accessToken

        if let refreshToken = credential.refreshToken {
            keychain["refreshToken"] = refreshToken
        }
    }
}

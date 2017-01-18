import Foundation
import APIKit
import RxSwift
import KeychainAccess

class RedditService {
    static let shared = RedditService()

    let clientID: String
    let session: Session

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

    init(clientID: String = RedditServiceConfiguration.clientID, session: Session = Session.shared) {
        self.clientID = clientID
        self.session = session
    }

    func fetchUserInfo(credential: RedditCredential? = nil) -> Observable<RedditUser> {
        if let credential = credential {
            storeCredential(credential)
        }

        let request = RedditAPI.UserRequest()
        return session.rx
            .response(request, service: self)
            .do(onNext: { user in
                self.currentUser = user
            })
    }

    func refreshAccessToken() -> Observable<RedditCredential> {
        guard let refreshToken = refreshToken else {
            fatalError("refresh token not found")
        }

        let request = RedditAPI.AccessTokenRequest(clientID: clientID, refreshToken: refreshToken)
        return session.rx
            .response(request, refreshAccessTokenWhenExpired: false, service: self)
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

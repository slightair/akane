import Foundation
import APIKit
import RxSwift
import KeychainAccess

class RedditDefaultService: RedditService {
    static let shared = RedditDefaultService(clientID: RedditServiceConfiguration.clientID)

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

    init(clientID: String, session: Session = Session.shared) {
        self.clientID = clientID
        self.session = session
    }

    func fetchUserInfo() -> Observable<RedditUser> {
        if !hasRefreshToken {
            return Observable.empty()
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

    func storeCredential(_ credential: RedditCredential) {
        let keychain = self.keychain

        keychain["accessToken"] = credential.accessToken

        if let refreshToken = credential.refreshToken {
            keychain["refreshToken"] = refreshToken
        }
    }
}

import Foundation
import APIKit
import RxSwift
import KeychainAccess

class RedditService {
    static let shared = RedditService()

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

    private(set) var currentUser: RedditUser?

    func fetchUserInfo(credential: RedditCredential) -> Observable<RedditUser> {
        storeCredential(credential)

        return fetchUserInfo()
    }

    func fetchUserInfo() -> Observable<RedditUser> {
        let request = RedditAPI.UserRequest()
        return Session.shared.rx
            .response(request)
            .do(onNext: { user in
                self.currentUser = user
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

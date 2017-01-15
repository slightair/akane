import Foundation
import APIKit
import Result

class RedditService {
    static let shared = RedditService()

    var isLogin: Bool {
        return currentUser != nil
    }

    var currentCredential: RedditCredential?
    var currentUser: RedditUser?

    func login(credential: RedditCredential, completion: @escaping ((Result<RedditUser, SessionTaskError>) -> Void)) {
        currentCredential = credential

        let request = RedditAPI.UserRequest()
        Session.send(request) { result in
            switch result {
            case .success(let user):
                self.currentUser = user

                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

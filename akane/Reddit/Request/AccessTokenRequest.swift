import Foundation
import APIKit

extension RedditAPI {
    struct AccessTokenRequest: RedditAPIRequest {
        typealias Response = RedditAccessToken

        let method: HTTPMethod = .post
        let path: String = "/api/v1/access_token"

        let clientID: String
        let grantType: GrantType

        enum GrantType {
            case authorizationCode(code: String, redirectURI: String)
            case refreshToken(String)
        }

        init(clientID: String, code: String, redirectURI: String) {
            self.clientID = clientID
            grantType = .authorizationCode(code: code, redirectURI: redirectURI)
        }

        init(clientID: String, refreshToken: String) {
            self.clientID = clientID
            grantType = .refreshToken(refreshToken)
        }

        var baseURL: URL {
            return URL(string: "https://www.reddit.com")!
        }

        var bodyParameters: BodyParameters? {
            let object: [String: Any]
            switch grantType {
            case .authorizationCode(let code, let redirectURI):
                object = [
                    "grant_type": "authorization_code",
                    "code": code,
                    "redirect_uri": redirectURI,
                ]
            case .refreshToken(let token):
                object = [
                    "grant_type": "refresh_token",
                    "refresh_token": token,
                ]
            }
            return FormURLEncodedBodyParameters(formObject: object)
        }

        var headerFields: [String : String] {
            let authValue = "\(clientID):".data(using: .ascii)?.base64EncodedString() ?? ""
            return [
                "Authorization": "Basic \(authValue)",
                "User-Agent": RedditAPI.userAgent,
            ]
        }
    }
}

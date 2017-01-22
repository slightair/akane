import Foundation
import Himotoki

struct RedditCredential {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let scope: [String]
    let refreshToken: String?
}

extension RedditCredential: Decodable {
    static func decode(_ e: Extractor) throws -> RedditCredential {
        return try RedditCredential(accessToken: e <| "access_token",
                                    tokenType: e <| "token_type",
                                    expiresIn: e <| "expires_in",
                                    scope: (e <| "scope" as String).components(separatedBy: " "),
                                    refreshToken: e <|? "refresh_token")
    }
}

func == (lhs: RedditCredential, rhs: RedditCredential) -> Bool {
    return
        lhs.accessToken == rhs.accessToken &&
        lhs.tokenType == rhs.tokenType &&
        lhs.expiresIn == rhs.expiresIn &&
        lhs.scope == rhs.scope &&
        lhs.refreshToken == rhs.refreshToken
}

extension RedditCredential: Equatable {}

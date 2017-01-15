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

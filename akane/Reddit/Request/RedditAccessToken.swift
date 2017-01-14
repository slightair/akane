import Foundation
import Himotoki

struct RedditAccessToken {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let scope: [String]
    let refreshToken: String?
}

extension RedditAccessToken: Decodable {
    static func decode(_ e: Extractor) throws -> RedditAccessToken {
        return try RedditAccessToken(accessToken: e <| "access_token",
                                     tokenType: e <| "token_type",
                                     expiresIn: e <| "expires_in",
                                     scope: (e <| "scope" as String).components(separatedBy: " "),
                                     refreshToken: e <|? "refresh_token")
    }
}

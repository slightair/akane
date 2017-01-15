import Foundation
import APIKit
import Himotoki

protocol RedditAPIRequest: Request {}

extension RedditAPIRequest {
    var baseURL: URL {
        return URL(string: "https://oauth.reddit.com")!
    }

    var headerFields: [String : String] {
        var accessToken: String?
        if let credential = RedditService.shared.currentCredential {
            accessToken = credential.accessToken
        }

        var fields = [
            "User-Agent": RedditAPI.userAgent,
        ]

        if let accessToken = accessToken {
            fields["Authorization"] = "Bearer \(accessToken)"
        }

        return fields
    }
}

extension RedditAPIRequest where Response: Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try Response.decodeValue(object)
    }
}

import Foundation
import Himotoki

struct RedditUser {
    let name: String
}

extension RedditUser: Decodable {
    static func decode(_ e: Extractor) throws -> RedditUser {
        return try RedditUser(name: e <| "name")
    }
}

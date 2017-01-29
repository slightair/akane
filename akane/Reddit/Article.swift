import Foundation
import Himotoki

struct Article {
    let title: String
    let name: String
}

extension Article: Decodable {
    static func decode(_ e: Extractor) throws -> Article {
        return try Article(title: e <| ["data", "title"],
                           name: e <| ["data", "name"])
    }
}

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

func == (lhs: Article, rhs: Article) -> Bool {
    return
        lhs.title == rhs.title &&
        lhs.name == rhs.name
}

extension Article: Equatable {}

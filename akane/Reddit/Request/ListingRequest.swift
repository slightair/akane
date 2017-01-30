import Foundation
import APIKit
import Himotoki

enum ListingRequestKind {
    case refresh
    case before(String)
    case after(String)
}

func == (lhs: ListingRequestKind, rhs: ListingRequestKind) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

extension ListingRequestKind: Equatable {}

extension ListingRequestKind: Hashable {
    var hashValue: Int {
        let type: Int
        let associatedName: String

        switch self {
        case .refresh:
            type = 1
            associatedName = ""
        case .before(let name):
            type = 2
            associatedName = name
        case .after(let name):
            type = 3
            associatedName = name
        }

        return type.hashValue ^ associatedName.hashValue
    }
}

protocol ListingRequest: Request {
    var requestKind: ListingRequestKind { get }
}

extension ListingRequest {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> ListingResponse {
        let elements = try decodeArray(object, rootKeyPath: ["data", "children"]) as [Article]

        return ListingResponse(elements: elements, requestKind: requestKind)
    }
}

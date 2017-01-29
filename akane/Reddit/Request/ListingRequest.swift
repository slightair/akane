import Foundation
import APIKit
import Himotoki

enum ListingRequestKind {
    case refresh
    case before(String)
    case after(String)
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

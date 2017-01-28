import Foundation
import APIKit
import Himotoki

protocol PaginationRequest: Request {
    associatedtype Response: PaginationResponse
    var page: Int { get }
}

extension PaginationRequest {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        let elements = try decodeArray(object, rootKeyPath: ["data", "children"]) as [Response.Element]

        return Response(elements: elements, page: page, nextPage: nil)
    }
}

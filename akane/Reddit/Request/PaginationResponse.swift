import Foundation
import Himotoki

protocol PaginationResponse {
    associatedtype Element: Decodable

    var elements: [Element] { get }
    var page: Int { get }
    var nextPage: Int? { get }

    init(elements: [Element], page: Int, nextPage: Int?)
}

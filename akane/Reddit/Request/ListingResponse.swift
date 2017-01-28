import Foundation
import Himotoki

struct ListingResponse: PaginationResponse {
    let elements: [Article]
    let page: Int
    let nextPage: Int?
}

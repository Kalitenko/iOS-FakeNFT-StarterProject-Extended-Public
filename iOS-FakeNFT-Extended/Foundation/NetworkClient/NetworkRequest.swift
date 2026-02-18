import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkRequest {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
    var dto: Encodable? { get }
    var bodyData: Data? { get }
    var contentType: String? { get }
}

// default values
extension NetworkRequest {
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
    var bodyData: Data? { nil }
    var contentType: String? { nil }
}

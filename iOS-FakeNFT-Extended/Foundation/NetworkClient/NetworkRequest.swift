import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkRequest: Sendable {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
    var dto: Encodable? { get }
    var bodyData: Data? { get }
    var contentType: String? { get }
    
    var body: Data? { get }
    var headers: [String: String]? { get }
}

// default values
extension NetworkRequest {
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
    var bodyData: Data? { nil }
    var contentType: String? { nil }
}

extension NetworkRequest {
    var body: Data? { nil }
    var headers: [String: String]? { nil }
}

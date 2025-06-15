//
//  Requestable.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/11/24.
//

import Foundation

protocol Requestable {
    associatedtype Response: Decodable

    var baseURL: String { get }
    var httpMethod: HttpMethod { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var headers: [String: String] { get }

    func makeURLRequest() -> URLRequest?
}

extension Requestable {
    func makeURL() -> URL? {
        guard var components = URLComponents(string: baseURL) else { return nil }
        components.path = path
        components.queryItems = queryItems.isEmpty ? nil : queryItems

        return components.url
    }
}

protocol JSONBodyRequestable: Requestable {
    var body: Encodable { get }
}

extension JSONBodyRequestable {
    /// NetworkManger에서 호출하는 메서드
    /// - Returns:
    ///     - URLRequest
    ///     - Body Data
    func makeURLRequest() throws -> (URLRequest, Data) {
        guard let url = makeURL() else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = try JSONEncoder().encode(body)

        return (urlRequest, body)
    }
}

//
//  Request.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/11/24.
//

import Foundation

final class Endpoint: Requestable {
    var baseURL: String
    var httpMethod: HttpMethod
    var path: String
    var queryItems: [URLQueryItem]
    var headers: [String: String]
    var bodyParameters: Encodable

    init(
        baseURL: String = "",
        httpMethod: HttpMethod,
        path: String,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        bodyParameters: Encodable
    ) {
        self.baseURL = baseURL
        self.httpMethod = httpMethod
        self.path = path
        self.queryItems = queryItems
        self.headers = headers
        self.bodyParameters = bodyParameters
    }

    func makeURLRequest() -> URLRequest? {
        guard let url = makeURL() else { return nil }

        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = httpMethod.rawValue

        return urlRequest
    }
}

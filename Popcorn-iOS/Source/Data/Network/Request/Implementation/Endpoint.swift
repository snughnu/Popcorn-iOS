//
//  Request.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/11/24.
//

import Foundation

final class Endpoint<R: Decodable>: Requestable {
    typealias Response = R

    let baseURL: String
    let httpMethod: HttpMethod
    let path: String
    let queryItems: [URLQueryItem]
    let headers: [String: String]

    init(
        baseURL: String = APIConstant.baseURL,
        httpMethod: HttpMethod,
        path: String,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:]
    ) {
        self.baseURL = baseURL
        self.httpMethod = httpMethod
        self.path = path
        self.queryItems = queryItems
        self.headers = headers
    }

    func makeURLRequest() -> URLRequest? {
        guard let url = makeURL() else { return nil }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = headers

        return urlRequest
    }
}

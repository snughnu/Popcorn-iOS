//
//  JSONBodyEndpoint.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 1/23/25.
//

import Foundation

struct JSONBodyEndpoint<R: Decodable>: Requestable {
    typealias Response = R

    let baseURL: String
    let httpMethod: HttpMethod
    let path: String
    let queryItems: [URLQueryItem]
    let headers: [String: String]
    let body: Encodable

    init(
        baseURL: String = APIConstant.baseURL,
        httpMethod: HttpMethod,
        path: String,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        body: Encodable
    ) {
        self.baseURL = baseURL
        self.httpMethod = httpMethod
        self.path = path
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
    }

    func makeURLRequest() -> URLRequest? {
        guard let url = makeURL() else {
            return nil
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = try? JSONEncoder().encode(body)
        urlRequest.httpBody = body

        return urlRequest
    }
}

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
        components.queryItems = queryItems

        return components.url
    }
}

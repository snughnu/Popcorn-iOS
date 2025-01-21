//
//  NetworkError.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 11/11/24.
//

import Foundation

enum NetworkError: LocalizedError {
    case unknown
    case components
    case urlRequest
    case server(ServerError)
    case emptyData
    case parsing
    case decoding(Error)

    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .components:
            return "Invalid URL components"
        case .urlRequest:
            return "Invalid URL request"
        case .server(let serverError):
            return "Server Error: \(serverError)"
        case .emptyData:
            return "Empty data"
        case .parsing:
            return "Failed to parse data"
        case .decoding(let error):
            return "Error While Decoding: \(error)"
        }
    }
}

enum ServerError: Int {
    case unknown
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
}

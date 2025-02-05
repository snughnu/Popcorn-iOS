//
//  NetworkManager.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 1/23/25.
//

import Foundation

protocol NetworkManagerProtocol {
    @discardableResult
    func request<Request: Requestable>(
        endpoint: Request,
        completion: @escaping (Result<Request.Response, NetworkError>) -> Void
    ) -> Cancellable?
}

final class NetworkManager: NetworkManagerProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    @discardableResult
    func request<Request: Requestable>(
        endpoint: Request,
        completion: @escaping (Result<Request.Response, NetworkError>) -> Void
    ) -> (any Cancellable)? {
        guard let request = endpoint.makeURLRequest() else {
            completion(.failure(NetworkError.invalidURL))
            return nil
        }

        let completionHandler: (Data?, URLResponse?, Error?) -> Void = { data, response, error in
            if let error {
                completion(.failure(NetworkError.requestFailed(error.localizedDescription)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.responseError))
                return
            }

            guard (200..<400) ~= httpResponse.statusCode else {
                if let serverError = ServerError(rawValue: httpResponse.statusCode) {
                    completion(.failure(NetworkError.serverError(serverError)))
                } else {
                    completion(.failure(NetworkError.unknown))
                }
                return
            }

            guard let data else {
                completion(.failure(NetworkError.emptyData))
                return
            }

            do {
                let decodedData: Request.Response = try JSONDecoder().decode(Request.Response.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(NetworkError.decodingError(error)))
            }
        }

//        let task: Cancellable
//
//        if let body = request.httpBody {
//            task = session.uploadTask(with: request, from: body, completionHandler: completionHandler)
//        } else {
//            task = session.dataTask(with: request, completionHandler: completionHandler)
//        }

        let task = session.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
        return task
    }
}

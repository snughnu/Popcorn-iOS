//
//  ImageFetchManager.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/5/25.
//

import Foundation

final class ImageFetchManager: ImageFetchManagerProtocol {
    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func fetchImage(from url: URL, completion: @escaping (Result<Data, ImageFetchError>) -> Void) {
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error as? URLError {
                if error.code == .badURL {
                    completion(.failure(.invalidURL))
                } else {
                    completion(.failure(.networkError))
                }
                return
            }

            guard let data, !data.isEmpty else {
                completion(.failure(.emptyData))
                return
            }

            completion(.success(data))
        }
        task.resume()
    }
}

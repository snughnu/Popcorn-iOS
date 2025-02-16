//
//  ImageFetchManagerRepository.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/5/25.
//

import Foundation

final class ImageFetchManagerRepository: ImageFetchManagerRepositoryProtocol {
    private let imageFetchManager: ImageFetchManagerProtocol

    init(imageFetchManager: ImageFetchManagerProtocol = ImageFetchManager()) {
        self.imageFetchManager = imageFetchManager
    }

    func fetchImage(url: URL, completion: @escaping (Result<Data, ImageFetchError>) -> Void) {
        imageFetchManager.fetchImage(from: url, completion: completion)
    }
}

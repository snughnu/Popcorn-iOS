//
//  ImageFetchUseCase.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/5/25.
//
import Foundation

final class ImageFetchUseCase: ImageFetchUseCaseProtocol {
    let repository: ImageFetchManagerRepositoryProtocol

    init(repository: ImageFetchManagerRepositoryProtocol) {
        self.repository = repository
    }

    func fetchImage(url: URL, completion: @escaping (Result<Data, ImageFetchError>) -> Void) {
        repository.fetchImage(url: url, completion: completion)
    }
}

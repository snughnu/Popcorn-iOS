//
//  FetchPopupListUseCase.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/9/25.
//

final class PopupFetchListUseCase: PopupFetchListUseCaseProtocol {
    private let repository: PopupListRepositoryProtocol

    init(repository: PopupListRepositoryProtocol) {
        self.repository = repository
    }

    func fetchPopupMainList(
        completion: @escaping (Result<(data: PopupMainList, hasNextPage: Bool), any Error>) -> Void
    ) {
        repository.fetchPopupMainList(completion: completion)
    }

    func fetchPopupOverview(
        category: PopupSectionCategory,
        page: Int,
        completion: @escaping (Result<[PopupOverview], any Error>) -> Void
    ) {
        repository.fetchPopupOverview(category: category, page: page) { result in
            switch result {
            case .success(let endpoint):
                completion(.success(endpoint))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

//
//  FetchPopupListUseCase.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/9/25.
//

final class PopupFetchListUseCase: PopupFetchListUseCaseProtocol {
    private let repository: PopupListRepositoryProtocol

    init(repository: PopupListRepositoryProtocol = PopupListRepository()) {
        self.repository = repository
    }

    func fetchPopupMainList(completion: @escaping (Result<PopupMainList, any Error>) -> Void) {
        repository.fetchPopupMainList(completion: completion)
    }

    func fetchCategorizedPopupList(completion: @escaping (Result<[PopupPreview], NetworkError>) -> Void) {
        // TODO: API 나온 후 구현
    }
}

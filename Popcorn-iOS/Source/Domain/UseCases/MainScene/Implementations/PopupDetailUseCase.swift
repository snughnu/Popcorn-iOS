//
//  PopupDetailUseCase.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/20/25.
//

import Foundation

final class PopupDetailUseCase: PopupDetailUseCaseProtocol {
    private let repository: PopupDetailRepositoryProtocol
    private let popupListSyncQueue = DispatchQueue(label: "com.popcorn.PopupDetailUseCase")

    init(repository: PopupDetailRepositoryProtocol) {
        self.repository = repository
    }

    func fetchPopupAllData(
        popupId: Int,
        completion: @escaping (Result<(PopupInformation, PopupRatingDistribution, PopupReviewList), Error>
        ) -> Void) {
        repository.fetchPopupAllData(popupId: popupId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(var (popupInfo, popupRatingDistribution, popupReviewList)):
                popupInfo.hashTags = self.extractHashTag(from: popupInfo)
                completion(.success((popupInfo, popupRatingDistribution, popupReviewList)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchPopupReviews(popupId: Int, completion: @escaping (Result<PopupReviewList, any Error>) -> Void) {
        repository.fetchPopupReviews(completion: completion)
    }

    func extractHashTag(from popupInformation: PopupInformation) -> [String] {
        let address = popupInformation.address
        let dDay = PopupDateFormatter.calculateDDay(from: popupInformation.endDate)
        return [address, dDay]
    }
}

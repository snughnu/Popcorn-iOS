//
//  PopupDetailUseCaseProtocol.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/20/25.
//

protocol PopupDetailUseCaseProtocol {
    func fetchPopupAllData(
        popupId: Int,
        completion: @escaping (Result<(PopupInformation, PopupRatingDistribution, PopupReviewList), Error>) -> Void
    )

    func fetchPopupReviews(popupId: Int, page: Int, completion: @escaping (Result<PopupReviewList, Error>) -> Void)

    func extractHashTag(from popupInformation: PopupInformation) -> [String]
}

extension PopupDetailUseCaseProtocol {
    func fetchPopupAllData(
        popupId: Int = 1,
        completion: @escaping (Result<(PopupInformation, PopupRatingDistribution, PopupReviewList), Error>) -> Void
    ) {
        fetchPopupAllData(popupId: popupId, completion: completion)
    }
}

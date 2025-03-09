//
//  DummyPopupDetailRepository.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/24/25.
//

@testable import Popcorn_iOS

final class DummyPopupDetailRepository: PopupDetailRepositoryProtocol {
    func togglePopupPick(popupId: Int, completion: @escaping (Result<Bool, any Error>) -> Void) {
    }
    
    func fetchPopupAllData(popupId: Int, completion: @escaping (
        Result<(Popcorn_iOS.PopupInformation, Popcorn_iOS.PopupRatingDistribution,
                Popcorn_iOS.PopupReviewList), any Error>) -> Void
    ) {
        completion(.failure(NetworkError.emptyData))
    }
    
    func fetchPopupReviews(
        popupId: Int,
        page: Int,
        completion: @escaping (Result<Popcorn_iOS.PopupReviewList, any Error>) -> Void
    ) {
        completion(.failure(NetworkError.emptyData))
    }
}

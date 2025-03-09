//
//  PopupDetailRepositoryProtocol.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/20/25.
//

import Foundation

protocol PopupDetailRepositoryProtocol {
    func fetchPopupAllData(
        popupId: Int,
        completion: @escaping (Result<(PopupInformation, PopupRatingDistribution, PopupReviewList), Error>) -> Void
    )

    func fetchPopupReviews(popupId: Int, page: Int, completion: @escaping (Result<PopupReviewList, Error>) -> Void)

    func togglePopupPick(popupId: Int, completion: @escaping (Result<Bool, Error>) -> Void)
    //  리뷰 좋아요 토글, 리뷰 작성 추가
}

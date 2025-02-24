//
//  PopupReviewListResponseDTO.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/20/25.
//

import Foundation

struct PopupReviewListResponseDTO: Decodable {
    let reviews: [PopupReviewResponseDTO]
}

struct PopupReviewResponseDTO: Decodable {
    let profileImageUrl: String?
    let nickName: String
    let reviewRating: Float
    let reviewDate: String
    let reviewImagesUrl: [String]?
    let reviewText: String
    let likeCount: Int
    let isLiked: Bool

    enum CodingKeys: String, CodingKey {
        case profileImageUrl = "reviewerImg"
        case nickName = "reviewer"
        case reviewRating = "rating"
        case reviewDate
        case reviewImagesUrl = "reviewImage"
        case reviewText
        case likeCount
        case isLiked
    }
}

extension PopupReviewResponseDTO {
    func toEntity() -> PopupReview {
        let errorDate = DateFormatter.apiDateFormatter.date(from: "1900-01-01 00:00:00")!
        let reviewDate = DateFormatter.apiDateFormatter.date(from: reviewDate) ?? errorDate

        return PopupReview(
            profileImageUrl: profileImageUrl,
            nickName: nickName,
            reviewRating: reviewRating,
            reviewDate: reviewDate,
            reviewImagesUrl: reviewImagesUrl,
            reviewText: reviewText,
            likeCount: likeCount,
            isLiked: isLiked
        )
    }
}

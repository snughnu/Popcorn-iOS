//
//  PopupReviewListResponseDTO.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/20/25.
//

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

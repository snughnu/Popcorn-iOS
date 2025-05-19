//
//  PopupReviewList.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/19/25.
//

import Foundation

struct PopupReviewList {
    let reviews: [PopupReview]
}

struct PopupReview {
    let profileImageUrl: String?
    let nickName: String
    let rating: Float
    let createdAt: Date
    let reviewImageUrls: [String]?
    let content: String
    let likeCount: Int
    let isLiked: Bool
}

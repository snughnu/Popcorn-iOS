//
//  PopupInformation.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 12/30/24.
//

import Foundation

struct PopupInformation {
    let popupImagesUrl: [String]
    let mainInformation: PopupMainInformation
    let detailInformation: PopupDetailInformation
    let totalReview: PopupTotalReview
}

struct PopupTotalReview {
    let averageRating: Float
    let starBreakDown: [Int: Int]
    let review: [PopupReview]
}

struct PopupReview {
    let profileImageUrl: String?
    let nickName: String
    let reviewRating: Float
    let reviewDate: Date
    let reviewImagesUrl: [String]?
    let reviewText: String
}

//
//  PopupInformation.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 12/30/24.
//

import Foundation

struct PopupInformation {
    let popupImages: [Data]
    let mainInformation: PopupMainInformation
    let detailInformation: PopupDetailInformation
    let totalReview: PopupTotalReview
}

struct PopupMainInformation {
    let popupTitle: String
    let startDate: Date
    let endDate: Date
    let isUserPick: Bool
    let hashTags: [String]?
}

struct PopupDetailInformation {
    let address: String
    let officialLink: String
    let businesesHours: String
    let introduce: String
}

struct PopupTotalReview {
    let averageRating: Float
    let starBreakDown: [Int: Int]
    let review: [PopupReview]
}

struct PopupReview {
    let profileImage: Data?
    let nickName: String
    let reviewRating: Float
    let reviewDate: Date
    let reviewImages: [Data]?
    let reviewText: String
}

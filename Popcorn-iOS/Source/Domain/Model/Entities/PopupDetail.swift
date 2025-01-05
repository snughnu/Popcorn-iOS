//
//  PopupDetail.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 12/30/24.
//

import Foundation

struct PopupDetailData {
    let popupDetail: PopupDetail
    let ratings: PopupRating
    let reviews: [PopupReview]
}

struct PopupDetail {
    let images: [Data]
    let title: String
    let startDate: Date
    let endDate: Date
    let tags: [String]
    let location: String
    let officialLink: String
    let businessHours: String
    let introduce: String

    var isUserPick: Bool
}

struct PopupRating {
    let averageRating: Float
    let starBreakDown: [Int: Int]
}

struct PopupReview {
    let author: String
    let profileImage: Data
    let rating: Float
    let reviewDate: Date
    let images: [Data]
    let content: String
}

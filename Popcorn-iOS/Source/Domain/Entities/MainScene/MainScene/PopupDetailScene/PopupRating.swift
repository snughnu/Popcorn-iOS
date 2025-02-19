//
//  PopupRating.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/19/25.
//

enum RatingDistribution: CaseIterable {
    case oneStar
    case twoStars
    case threeStars
    case fourStars
    case fiveStars
    
    var titleDescription: String {
        switch self {
        case .fiveStars: "매우만족"
        case .fourStars: "만족"
        case .threeStars: "보통"
        case .twoStars: "별로"
        case .oneStar: "매우별로"
        }
    }
}

struct PopupRatingDistribution {
    let averageRating: Float
    let ratingDistribution: [RatingDistribution: Int]
}

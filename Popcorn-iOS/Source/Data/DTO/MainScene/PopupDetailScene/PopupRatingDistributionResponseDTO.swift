//
//  PopupRatingDistributionResponseDTO.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/20/25.
//

struct PopupRatingDistributionResponseDTO: Decodable {
    let averageRating: Float
    let ratingDistribution: [Int: Int]

    enum CodingKeys: String, CodingKey {
        case averageRating
        case ratingDistribution = "distribution"
    }
}

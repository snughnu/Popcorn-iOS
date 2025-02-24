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

extension PopupRatingDistributionResponseDTO {
    func toEntity() -> PopupRatingDistribution {
        var entityRatingDistribution = [RatingDistribution: Int]()

        RatingDistribution.allCases.forEach { rating in
            entityRatingDistribution[rating] = ratingDistribution[rating.ratingIndex]
        }

        return PopupRatingDistribution(averageRating: averageRating, ratingDistribution: entityRatingDistribution)
    }
}

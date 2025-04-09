//
//  PopupMainListResponseDTO.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/5/25.
//

import Foundation

struct PopupMainListResponseDTO: Decodable {
    let todayRecommendPopups: [PopupPreviewResponseDTO]
    let userPickPopups: [PopupPreviewResponseDTO]
    let userInterestPopups: [InterestCategoryDTO: [PopupPreviewResponseDTO]]
    let closingSoonPopups: [PopupPreviewResponseDTO]
    let totalPages: Int
    let currentPages: Int

    enum CodingKeys: String, CodingKey {
        case todayRecommendPopups
        case userPickPopups = "topLikedPopups"
        case userInterestPopups = "categoryPopups"
        case closingSoonPopups = "allPopups"
        case totalPages
        case currentPages
    }
}

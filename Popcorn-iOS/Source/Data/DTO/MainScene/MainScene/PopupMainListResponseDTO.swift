//
//  PopupMainListResponseDTO.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/5/25.
//

import Foundation

struct PopupMainListResponseDTO: Decodable {
    let todayRecommendPopups: [PopupPreviewResponseDTO]
    let userPickPopups: [PopupPreviewResponseDTO]?
    let userInterestPopups: [String: [PopupPreviewResponseDTO]]?
    let closingSoonPopups: [PopupPreviewResponseDTO]
    let totalPage: Int
    let currentPage: Int

    enum CodingKeys: String, CodingKey {
        case todayRecommendPopups = "todayRecommend"
        case userPickPopups = "topLikedPopups"
        case userInterestPopups = "interestedPopups"
        case closingSoonPopups = "allPopups"
        case totalPage = "totalPages"
        case currentPage
    }
}

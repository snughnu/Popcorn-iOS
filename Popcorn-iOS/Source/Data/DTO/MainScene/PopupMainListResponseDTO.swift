//
//  PopupMainListResponseDTO.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/5/25.
//

struct PopupMainListResponseDTO: Decodable {
    let userPickPopups: [PopupPreviewResponseDTO]
    let userInterestPopups: [String: PopupPreviewResponseDTO]
    let closingSoonPopups: [PopupPreviewResponseDTO]

    enum CodingKeys: String, CodingKey {
        case userPickPopups = "topLikedPopups"
        case userInterestPopups = "categoryPopups"
        case closingSoonPopups = "allPopups"
    }
}

struct PopupPreviewResponseDTO: Decodable {
    let popupId: Int
    let title: String
    let imageUrl: String
    let startDate: String
    let endDate: String
    let address: String
}

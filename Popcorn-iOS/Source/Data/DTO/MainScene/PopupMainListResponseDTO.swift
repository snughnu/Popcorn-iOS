//
//  PopupMainListResponseDTO.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/5/25.
//

import Foundation

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

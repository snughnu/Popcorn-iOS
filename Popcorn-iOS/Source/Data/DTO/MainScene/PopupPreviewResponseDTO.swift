//
//  PopupPreviewResponseDTO.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/6/25.
//

struct PopupPreviewResponseDTO: Decodable {
    let popupId: Int
    let title: String
    let imageUrl: String
    let startDate: String
    let endDate: String
    let address: String
}

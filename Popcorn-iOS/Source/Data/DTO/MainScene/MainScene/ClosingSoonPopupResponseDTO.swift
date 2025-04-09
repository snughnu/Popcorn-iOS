//
//  ClosingSoonPopupResponseDTO.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 4/9/25.
//

struct ClosingSoonPopupResponseDTO: Decodable {
    let popups: [PopupPreviewResponseDTO]
    let totalPages: Int
    let currentPages: Int
}

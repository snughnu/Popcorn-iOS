//
//  PopupPreviewResponseDTO.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/6/25.
//

import Foundation

struct PopupPreviewResponseDTO: Decodable {
    let popupId: Int
    let title: String
    let imageUrl: String
    let startDate: String
    let endDate: String
    let address: String
}

extension PopupPreviewResponseDTO {
    func toEntity() -> PopupPreview {
        let errorDate = DateFormatter.apiDateFormatter.date(from: "1900-01-01 00:00:00")!
        let endDate = DateFormatter.apiDateFormatter.date(from: endDate) ?? errorDate
        let startDate = DateFormatter.apiDateFormatter.date(from: startDate) ?? errorDate

        return PopupPreview(
            popupId: popupId,
            popupImageUrl: imageUrl,
            popupTitle: title,
            popupEndDate: endDate,
            popupStartDate: startDate,
            popupLocation: address
        )
    }
}

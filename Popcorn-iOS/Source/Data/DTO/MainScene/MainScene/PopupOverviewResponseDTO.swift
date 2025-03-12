//
//  PopupOverviewResponseDTO.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 3/12/25.
//

import Foundation

struct PopupOverviewResponseDTO: Decodable {
    let popupImageUrl: String
    let popupTitle: String
    let startDate: String
    let endDate: String
    let address: String
}

extension PopupOverviewResponseDTO {
    func toEntity() -> PopupOverview {
        let errorDate = DateFormatter.apiDateFormatter.date(from: "1900-01-01 00:00:00")!
        let endDate = DateFormatter.apiDateFormatter.date(from: endDate) ?? errorDate
        let startDate = DateFormatter.apiDateFormatter.date(from: startDate) ?? errorDate
        
        return PopupOverview(
            popupImageUrl: popupImageUrl,
            popupTitle: popupTitle,
            startDate: startDate,
            endDate: endDate,
            address: address
        )
    }
}

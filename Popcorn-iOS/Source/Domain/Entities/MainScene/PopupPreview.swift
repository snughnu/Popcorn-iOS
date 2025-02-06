//
//  PopupPreview.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/17/24.
//

import Foundation

struct PopupPreview {
    let popupImageUrl: String
    let popupTitle: String
    let popupEndDate: Date
    let popupStartDate: Date?
    let popupLocation: String?

    init(
        popupImageUrl: String,
        popupTitle: String,
        popupEndDate: Date,
        popupStartDate: Date? = nil,
        popupLocation: String? = nil
    ) {
        self.popupImageUrl = popupImageUrl
        self.popupTitle = popupTitle
        self.popupEndDate = popupEndDate
        self.popupStartDate = popupStartDate
        self.popupLocation = popupLocation
    }
}

//
//  PopupPreview.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/17/24.
//

import Foundation

struct PopupPreview {
    let popupImage: Data
    let popupTitle: String
    let popupEndDate: Date
    let popupStartDate: Date?
    let popupLocation: String?

    init(
        popupImage: Data,
        popupTitle: String,
        popupEndDate: Date,
        popupStartDate: Date? = nil,
        popupLocation: String? = nil
    ) {
        self.popupImage = popupImage
        self.popupTitle = popupTitle
        self.popupEndDate = popupEndDate
        self.popupStartDate = popupStartDate
        self.popupLocation = popupLocation
    }
}

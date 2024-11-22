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
    let popupDueDate: Date
    let popupStartDate: Date?
    let popupLocation: String?

    init(
        popupImage: Data,
        popupTitle: String,
        popupDueDate: Date,
        popupStartDate: Date? = nil,
        popupLocation: String? = nil
    ) {
        self.popupImage = popupImage
        self.popupTitle = popupTitle
        self.popupDueDate = popupDueDate
        self.popupStartDate = popupStartDate
        self.popupLocation = popupLocation
    }
}

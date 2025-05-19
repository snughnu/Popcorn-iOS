//
//  PopupPreview.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/17/24.
//

import Foundation

struct PopupPreview {
    let id: Int
    let imageUrl: String
    let title: String
    let endDate: Date
    let startDate: Date?
    let location: String?

    init(
        popupId: Int,
        popupImageUrl: String,
        popupTitle: String,
        popupEndDate: Date,
        popupStartDate: Date? = nil,
        popupLocation: String? = nil
    ) {
        self.id = popupId
        self.imageUrl = popupImageUrl
        self.title = popupTitle
        self.endDate = popupEndDate
        self.startDate = popupStartDate
        self.location = popupLocation
    }
}

//
//  ClosingSoonPopupPreview.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/19/24.
//

import Foundation

struct ClosingSoonPopupPreview: PopupPreviewRepresentable {
    let popupImage: Data
    let popupTitle: String
    let popupStartDate: Date
    let popupDueDate: Date
    let popupLocation: String
    let isPick: Bool
}

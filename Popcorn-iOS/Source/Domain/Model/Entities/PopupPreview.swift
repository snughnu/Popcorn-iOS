//
//  PopupPreview.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/17/24.
//

import Foundation

struct PopupPreview: PopupPreviewRepresentable {
    let popupImage: Data
    let popupTitle: String
    let popupDueDate: Date
    let isPick: Bool
}

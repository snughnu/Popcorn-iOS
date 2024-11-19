//
//  BasicPopupPreview.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/19/24.
//

import Foundation

struct BasicPopupPreview: PopupPreviewRepresentable {
    let popUpImage: Data
    let popUpTitle: String
    let popUpstartDate: Date
    let popUpDueDate: Date
    let popUpLocation: String
    let isPick: Bool
}

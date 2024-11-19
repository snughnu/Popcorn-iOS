//
//  PopupPreview.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/17/24.
//

import Foundation

struct PopupPreview: PopupPreviewRepresentable {
    let popUpImage: Data
    let popUpTitle: String
    let popUpDueDate: Date
    let isPick: Bool
}

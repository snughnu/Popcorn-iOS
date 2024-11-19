//
//  PopupPreviewRepresentable.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/19/24.
//

import Foundation

protocol PopupPreviewRepresentable {
    var popupImage: Data { get }
    var popupTitle: String { get }
    var popupDueDate: Date { get }
    var isPick: Bool { get }
}

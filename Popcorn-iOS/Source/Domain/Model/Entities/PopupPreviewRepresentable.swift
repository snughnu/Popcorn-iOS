//
//  PopupPreviewRepresentable.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/19/24.
//

import Foundation

protocol PopupPreviewRepresentable {
    var popUpImage: Data { get }
    var popUpTitle: String { get }
    var popUpDueDate: Date { get }
    var isPick: Bool { get }
}

//
//  ConfigurablePopupPreviewCell.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 5/7/25.
//

import UIKit

protocol PopupPreviewCellable {
    func configure(with popupData: PopupPreviewViewData, image: UIImage)
}

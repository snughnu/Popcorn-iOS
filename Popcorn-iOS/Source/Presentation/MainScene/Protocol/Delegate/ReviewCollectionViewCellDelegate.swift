//
//  ReviewCollectionViewCellDelegate.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 1/12/25.
//

import UIKit

protocol ReviewCollectionViewCellDelegate: AnyObject {
    func didTapReviewImages(images: [UIImage], selecetedIndex: Int)
}

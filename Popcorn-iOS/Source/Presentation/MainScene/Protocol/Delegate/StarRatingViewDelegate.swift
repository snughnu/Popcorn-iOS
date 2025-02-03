//
//  StarRatingViewDelegate.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 1/12/25.
//

import UIKit

protocol StarRatingViewDelegate: AnyObject {
    func didChangeRating(to rating: Float)
}

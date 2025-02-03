//
//  MainCarouselDataSource.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 12/28/24.
//

import UIKit

protocol MainCarouselViewModelProtocol: AnyObject {
    var carouselPopupImage: [UIImage] { get set }

    var carouselImagePublisher: (() -> Void)? { get set }

    func numbersOfCarouselImage() -> Int

    func provideCarouselImage() -> [UIImage]
}

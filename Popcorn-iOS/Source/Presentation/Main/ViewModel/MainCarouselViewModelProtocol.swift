//
//  MainCarouselDataSource.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 12/28/24.
//

protocol MainCarouselViewModelProtocol {
    var carouselPopupImage: [PopupPreview] { get set }

    var carouselImagePublisher: (() -> Void)? { get set }

    func numbersOfCarouselImage() -> Int

    func provideCarouselImage(at index: Int) -> PopupPreviewData?
}

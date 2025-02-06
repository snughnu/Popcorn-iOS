//
//  MainCarouselViewModelProtocol.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 12/28/24.
//

import Foundation

protocol MainCarouselViewModelProtocol: AnyObject {
    var carouselPopupImageUrl: [String] { get set }

    var carouselImagePublisher: (() -> Void)? { get set }

    func numbersOfCarouselImage() -> Int

    func provideCarouselImage() -> [String]

    func fetchImage(url: String, completion: @escaping (Result<Data, ImageFetchError>) -> Void)
}

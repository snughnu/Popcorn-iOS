//
//  MainCarouselViewModelProtocol.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 12/28/24.
//

import Foundation

protocol MainCarouselViewModelProtocol: AnyObject {
    /// MainCarouselView 파일에서 캐러셀 컬렉션뷰의 데이터와 개수를 얻기 위한 퍼블리셔
    var carouselImagePublisher: (() -> Void)? { get set }

    func numbersOfCarouselImage() -> Int

    func provideCarouselImageUrl(at indexPath: IndexPath) -> String

    func fetchImage(url: String, completion: @escaping (Result<Data, ImageFetchError>) -> Void)
}

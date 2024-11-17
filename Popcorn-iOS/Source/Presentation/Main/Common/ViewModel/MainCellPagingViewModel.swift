//
//  MainCellPagingViewModel.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/16/24.

import UIKit

final class MainCellPagingViewModel {
    private var popUpImageData: [Data] = [] {
        didSet {
            popUpImagesPublisher?()
        }
    }

    private var currentPage: Int = 0 {
        didSet {
            currentPagePublisher?(currentPage)
        }
    }

    // MARK: - Output
    var popUpImagesPublisher: (() -> Void)?
    var currentPagePublisher: ((Int) -> Void)?

    init() {
    }

    func numberOfImages() -> Int {
        return popUpImageData.count
    }

    func image(at index: Int) -> Data {
        return popUpImageData[index]
    }

    func updateCurrentPage(at currentPage: Int) {
        self.currentPage = currentPage
    }
}

extension MainCellPagingViewModel {
    func fetchPopupImages(images: [Data]) {
        popUpImageData = images
    }
}

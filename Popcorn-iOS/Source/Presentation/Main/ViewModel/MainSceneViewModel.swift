//
//  MainSceneViewModel.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/17/24.
//

import Foundation

enum MainCategory {
    case todayRecommended
    case userPick
    case userInterest
}

class MainSceneViewModel {
    var todayRecommendedPopup: [PopupPreview] = [] {
        didSet {
            todayRecommendedPopupPublisher?()
        }
    }

    var userPickPopup: [PopupPreview] = [] {
        didSet {
            userPickPopupPublisher?()
        }
    }

    var userInterestPopup: [UserInterestPopup] = [] {
        didSet {
            userInterestPopupPublihser?()
        }
    }

    private var currentTodayRecommendPopupPages: Int = 0 {
        didSet {
            currentPagePublisher?(currentTodayRecommendPopupPages)
        }
    }

    // MARK: - Output
    var todayRecommendedPopupPublisher: (() -> Void)?
    var userPickPopupPublisher: (() -> Void)?
    var userInterestPopupPublihser: (() -> Void)?
    var currentPagePublisher: ((Int) -> Void)?

    init() {
    }

    func numbersOfPopup(of category: MainCategory) -> Int {
        switch category {
        case .todayRecommended:
            return todayRecommendedPopup.count
        case .userPick:
            return userPickPopup.count
        case .userInterest:
            return userInterestPopup.count
        }
    }

    func popupPreview(at index: Int, of category: MainCategory, row: Int = 0) -> PopupPreview {
        switch category {
        case .todayRecommended:
            return todayRecommendedPopup[index]
        case .userPick:
            return userPickPopup[index]
        case .userInterest:
            return userInterestPopup[index].popups[row]
        }
    }

    func updateCurrentPage(at currentPage: Int) {
        self.currentTodayRecommendPopupPages = currentPage
    }
}

// MARK: - Input
extension MainSceneViewModel {
    func fetchPopupImages(images: [Data]) {
    }
}

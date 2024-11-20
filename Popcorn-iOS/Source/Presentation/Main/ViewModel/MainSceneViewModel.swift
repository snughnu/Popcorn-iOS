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
    case basic
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

    var basicPopup: [BasicPopupPreview] = [] {
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
    var basicPopupPublisher: (() -> Void)?
    var currentPagePublisher: ((Int) -> Void)?

    init() {
    }

    func numbersOfPopup(of category: MainCategory, at index: Int = 0) -> Int {
        switch category {
        case .todayRecommended:
            return todayRecommendedPopup.count
        case .userPick:
            return userPickPopup.count
        case .userInterest:
            return userInterestPopup[index].popups.count
        case .basic:
            return basicPopup.count
        }
    }

    func numbersOfInterest() -> Int {
        return userInterestPopup.count
    }

    func providePopupPreviewData(
        of category: MainCategory,
        at index: Int,
        sectionOfInterest: Int = 0
    ) -> PopupPreviewRepresentable {
        switch category {
        case .todayRecommended:
            return todayRecommendedPopup[index]
        case .userPick:
            return userPickPopup[index]
        case .userInterest:
            return userInterestPopup[sectionOfInterest].popups[index]
        case .basic:
            return basicPopup[index]
        }
    }

    func updateCurrentPage(at currentPage: Int) {
        self.currentTodayRecommendPopupPages = currentPage
    }

    func calculateDaysUntil(targetDate: Date) -> Int {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let startOfTargetDate = calendar.startOfDay(for: targetDate)

        let components = calendar.dateComponents([.day], from: startOfTargetDate, to: startOfDay)
        return components.day ?? 0
    }
}

// MARK: - Input
extension MainSceneViewModel {
    func fetchPopupImages(images: [Data]) {
    }
}

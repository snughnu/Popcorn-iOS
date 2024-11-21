//
//  MainSceneViewModel.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/17/24.
//

import UIKit

enum MainCategory {
    case todayRecommended
    case userPick
    case userInterest
    case closingSoon
}

struct PopUpPreviewData {
    let popupImage: UIImage
    let popupTitle: String?
    let popupStartDate: String?
    let popupDueDate: String?
    let popupLocation: String?
    let popupDDay: String?
    let isPick: Bool?

    init(
        popupImage: UIImage,
        popupTitle: String? = nil,
        popupStartDate: String? = nil,
        popupDueDate: String? = nil,
        popupLocation: String? = nil,
        popupDDay: String? = nil,
        isPick: Bool? = nil
    ) {
        self.popupImage = popupImage
        self.popupTitle = popupTitle
        self.popupStartDate = popupStartDate
        self.popupDueDate = popupDueDate
        self.popupLocation = popupLocation
        self.popupDDay = popupDDay
        self.isPick = isPick
    }
}

class MainSceneViewModel {
    private var todayRecommendedPopup: [PopupPreview] = [] {
        didSet {
            todayRecommendedPopupPublisher?()
        }
    }

    private var userPickPopup: [PopupPreview] = [] {
        didSet {
            userPickPopupPublisher?()
        }
    }

    private var userInterestPopup: [UserInterestPopup] = [] {
        didSet {
            userInterestPopupPublihser?()
        }
    }

    private var closingSoonPopup: [PopupPreview] = [] {
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
    var closingSoonPopupPublisher: (() -> Void)?
    var currentPagePublisher: ((Int) -> Void)?

    init() {
    }

    private func preparePopupPreview(
        of category: MainCategory,
        popupData: PopupPreview
    ) -> PopUpPreviewData? {
        if let popupImage = UIImage(data: popupData.popupImage) {
            if category == .todayRecommended {
                return PopUpPreviewData(popupImage: popupImage)
            }
            else if category == .userInterest || category == .userPick {
                let dDay = calculateDDay(from: popupData.popupDueDate)
                return PopUpPreviewData(
                    popupImage: popupImage,
                    popupTitle: popupData.popupTitle,
                    popupDDay: "D-\(dDay)"
                )
            }
            else if category == .closingSoon,
                    let popupStartDate = popupData.popupStartDate,
                    let popupLocation = popupData.popupLocation {
                return PopUpPreviewData(
                    popupImage: popupImage,
                    popupTitle: popupData.popupTitle,
                    popupStartDate: popupStartDate.toYYMMDDString(),
                    popupDueDate: popupData.popupDueDate.toYYMMDDString(),
                    popupLocation: popupLocation,
                    isPick: popupData.isPick
                )
            }
        }

        return nil
    }

    private func calculateDDay(from dueDate: Date) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let due = calendar.startOfDay(for: dueDate)
        let components = calendar.dateComponents([.day], from: today, to: due).day ?? 0
        return String(components)
    }
}

// MARK: - Input
extension MainSceneViewModel {
    func fetchPopupImages(images: [Data]) {
    }
}

// MARK: - Public Interface
extension MainSceneViewModel {
    func numbersOfPopup(of category: MainCategory, at index: Int = 0) -> Int {
        switch category {
        case .todayRecommended:
            return todayRecommendedPopup.count
        case .userPick:
            return userPickPopup.count
        case .userInterest:
            return userInterestPopup[index].popups.count
        case .closingSoon:
            return closingSoonPopup.count
        }
    }

    func numbersOfInterest() -> Int {
        return userInterestPopup.count
    }

    func providePopupPreviewData(
        of category: MainCategory,
        at index: Int,
        sectionOfInterest: Int = 0
    ) -> PopUpPreviewData? {
        let popupData: PopupPreview

        switch category {
        case .todayRecommended:
            popupData = todayRecommendedPopup[index]
            return preparePopupPreview(of: .todayRecommended, popupData: popupData)
        case .userPick:
            popupData = userPickPopup[index]
            return preparePopupPreview(of: .userPick, popupData: popupData)
        case .userInterest:
            popupData = userInterestPopup[sectionOfInterest].popups[index]
            return preparePopupPreview(of: .userInterest, popupData: popupData)
        case .closingSoon:
            popupData = closingSoonPopup[index]
            return preparePopupPreview(of: .closingSoon, popupData: popupData)
        }
    }

    func updateCurrentPage(at currentPage: Int) {
        self.currentTodayRecommendPopupPages = currentPage
    }
}

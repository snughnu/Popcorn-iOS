//
//  MainSceneDataSource.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/12/25.
//

import Foundation

final class MainSceneDataSource {
    private var carouselPopupImageUrls: [PopupPreviewViewData] = []
    private var userPickPopup: [PopupPreviewViewData] = []
    private var userInterestPopup: [UserInterestPopupViewData] = []
    private var closingSoonPopup: [PopupPreviewViewData] = []
}

// MARK: - Input
extension MainSceneDataSource {
    func updateData(_ popupMainList: PopupMainList) {
        self.carouselPopupImageUrls = popupMainList.recommendedPopups.compactMap { PopupPreviewViewData(from: $0)}
        self.userPickPopup = popupMainList.userPickPopups.compactMap { PopupPreviewViewData(from: $0) }
        self.closingSoonPopup = popupMainList.closingSoonPopup.compactMap { PopupPreviewViewData(from: $0) }

        self.userInterestPopup = popupMainList.userInterestPopup
            .map { category in
                return UserInterestPopupViewData(
                    interestCategory: category.interestCategory.rawValue,
                    popups: category.popups.compactMap { PopupPreviewViewData(from: $0) }
                )
            }
            .sorted { $0.interestCategory < $1.interestCategory }
    }
}

// MARK: - Output
extension MainSceneDataSource {
    func numbersOfPopup(of category: PopupSectionCategory, at index: Int = 0) -> Int {
        switch category {
        case .todayRecommend:
            return carouselPopupImageUrls.count
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

    func getCarouselPopupId(at index: Int) -> Int {
        guard index < carouselPopupImageUrls.count else { return 0 }
        return carouselPopupImageUrls[index].popupId
    }

    func item(at indexPath: IndexPath) -> PopupPreviewViewData {
        switch indexPath.section {
        case 0:
            return userPickPopup[indexPath.row]
        case 1..<(1 + userInterestPopup.count):
            return userInterestPopup[indexPath.section - 1].popups[indexPath.row]
        case (1 + userInterestPopup.count):
            return closingSoonPopup[indexPath.row]
        default:
            return PopupPreviewViewData.placeholder
        }
    }

    func showPlaceholderData() {
        self.carouselPopupImageUrls = []
        self.userPickPopup = [PopupPreviewViewData.placeholder]
        self.userInterestPopup = [
            UserInterestPopupViewData(interestCategory: "관심사", popups: [PopupPreviewViewData.placeholder])
        ]
        self.closingSoonPopup = [PopupPreviewViewData.placeholder]
    }

    func provideUserInterestTitle(sectionOfInterest: Int) -> String {
        return userInterestPopup[sectionOfInterest].interestCategory
    }
}

// MARK: - Mocking
extension MainSceneDataSource {
    func genereateMockData() {
        let mockPopups = MainSceneMockDataConstant.generatePopupPreview()

        self.carouselPopupImageUrls = [
            PopupPreviewViewData(from: mockPopups[3]),
            PopupPreviewViewData(from: mockPopups[1]),
            PopupPreviewViewData(from: mockPopups[2]),
            PopupPreviewViewData(from: mockPopups[3])
        ]

        self.userPickPopup = mockPopups.map { PopupPreviewViewData(from: $0) }
        self.userInterestPopup = [
            UserInterestPopupViewData(interestCategory: "캐릭터", popups: [
                PopupPreviewViewData(from: mockPopups[0]),
                PopupPreviewViewData(from: mockPopups[2]),
                PopupPreviewViewData(from: mockPopups[1]),
                PopupPreviewViewData(from: mockPopups[3])
            ]),
            UserInterestPopupViewData(interestCategory: "패션", popups: [
                PopupPreviewViewData(from: mockPopups[4]),
                PopupPreviewViewData(from: mockPopups[3]),
                PopupPreviewViewData(from: mockPopups[2]),
                PopupPreviewViewData(from: mockPopups[1])
            ])
        ]

        self.closingSoonPopup = [
            PopupPreviewViewData(from: mockPopups[0]),
            PopupPreviewViewData(from: mockPopups[2]),
            PopupPreviewViewData(from: mockPopups[3]),
            PopupPreviewViewData(from: mockPopups[2]),
            PopupPreviewViewData(from: mockPopups[1])
        ]
    }
}

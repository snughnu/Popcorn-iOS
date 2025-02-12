//
//  MainSceneDataSource.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/12/25.
//

import Foundation

enum MainCategory {
    case todayRecommend
    case userPick
    case userInterest
    case closingSoon
}

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
    func numbersOfPopup(of category: MainCategory, at index: Int = 0) -> Int {
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

    func providePopupPreviewData(
        of category: MainCategory,
        at index: Int,
        sectionOfInterest: Int = 0
    ) -> PopupPreviewViewData {
        switch category {
        case .todayRecommend:
            return carouselPopupImageUrls[index]
        case .userPick:
            return userPickPopup[index]
        case .userInterest:
            return userInterestPopup[sectionOfInterest].popups[index]
        case .closingSoon:
            return closingSoonPopup[index]
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
        let imageUrl1 = "https://velog.velcdn.com/images/gration77/post/e15e428d-2a5b-47fb-98a5-43f28d20ea58/image.jpeg"
        let imageUrl2 = "https://velog.velcdn.com/images/gration77/post/3a6ba214-83b1-4c08-99f6-e973d1a3bb5e/image.png"
        let imageUrl3 = "https://velog.velcdn.com/images/gration77/post/4ad770f3-e573-48e8-a2ee-2ca3c302f122/image.png"

        let mockPopups: [PopupPreviewViewData] = [
            PopupPreviewViewData(from: PopupPreview(
                popupId: 1,
                popupImageUrl: imageUrl1,
                popupTitle: "아기자기 팝업스토어",
                popupEndDate: Date().addingTimeInterval(86400 * 10),
                popupStartDate: Date().addingTimeInterval(-86400 * 5),
                popupLocation: "서울특별시 강남구"
            )),
            PopupPreviewViewData(from: PopupPreview(
                popupId: 2,
                popupImageUrl: imageUrl2,
                popupTitle: "핑구 팝업스토어",
                popupEndDate: Date().addingTimeInterval(86400 * 3),
                popupStartDate: Date().addingTimeInterval(-86400 * 2),
                popupLocation: "서울특별시 마포구"
            )),
            PopupPreviewViewData(from: PopupPreview(
                popupId: 3,
                popupImageUrl: imageUrl3,
                popupTitle: "트렌드 패션 팝업스토어",
                popupEndDate: Date().addingTimeInterval(86400 * 7),
                popupStartDate: Date().addingTimeInterval(-86400 * 1),
                popupLocation: "서울특별시 서초구"
            ))
        ]

        self.carouselPopupImageUrls = [mockPopups[0], mockPopups[1], mockPopups[2]]
        self.userPickPopup = mockPopups
        self.userInterestPopup = [
            UserInterestPopupViewData(interestCategory: "캐릭터", popups: [mockPopups[1]]),
            UserInterestPopupViewData(interestCategory: "패션", popups: [mockPopups[2], mockPopups[0]])
        ]
        self.closingSoonPopup = [mockPopups[2], mockPopups[1], mockPopups[0]]
    }
}

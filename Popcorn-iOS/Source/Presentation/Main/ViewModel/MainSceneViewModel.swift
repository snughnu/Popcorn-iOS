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

struct PopupPreviewData {
    let popupImage: UIImage
    let popupTitle: String?
    let popupStartDate: String?
    let popupEndDate: String?
    let popupLocation: String?
    let popupDDay: String?
    let isPick: Bool?

    init(
        popupImage: UIImage,
        popupTitle: String? = nil,
        popupStartDate: String? = nil,
        popupEndDate: String? = nil,
        popupLocation: String? = nil,
        popupDDay: String? = nil,
        isPick: Bool? = nil
    ) {
        self.popupImage = popupImage
        self.popupTitle = popupTitle
        self.popupStartDate = popupStartDate
        self.popupEndDate = popupEndDate
        self.popupLocation = popupLocation
        self.popupDDay = popupDDay
        self.isPick = isPick
    }
}

class MainSceneViewModel: MainCarouselViewModelProtocol {
    // 프로토콜 멤버의 접근제어는 모두 동일한데, 구현체에서 얘를 private으로 설정하니 프로토콜에서 정의된 접근제어자와 일치하지 않는다는 에러 발생..
    // 그래서 internal로 냅뒀습니다..
    var carouselPopupImage: [PopupPreview] = [] {
        didSet {
            carouselImagePublisher?()
        }
    }

    private var userPickPopup: [PopupPreview] = [] {
        didSet {
            userPickPopupPublisher?()
        }
    }

    private var userInterestPopup: [UserInterestPopup] = [] {
        didSet {
            userInterestPopupPublisher?()
        }
    }

    private var closingSoonPopup: [PopupPreview] = [] {
        didSet {
            userInterestPopupPublisher?()
        }
    }

    // MARK: - Output
    var carouselImagePublisher: (() -> Void)?
    var userPickPopupPublisher: (() -> Void)?
    var userInterestPopupPublisher: (() -> Void)?
    var closingSoonPopupPublisher: (() -> Void)?

    init() {
    }

    private func preparePopupPreview(
        of category: MainCategory,
        popupData: PopupPreview
    ) -> PopupPreviewData? {
        if let popupImage = UIImage(data: popupData.popupImage) {
            if category == .todayRecommended {
                return PopupPreviewData(popupImage: popupImage)
            }
            else if category == .userInterest || category == .userPick {
                let dDay = calculateDDay(from: popupData.popupEndDate)
                return PopupPreviewData(
                    popupImage: popupImage,
                    popupTitle: popupData.popupTitle,
                    popupDDay: "D-\(dDay)"
                )
            }
            else if category == .closingSoon,
                    let popupStartDate = popupData.popupStartDate,
                    let popupLocation = popupData.popupLocation {
                return PopupPreviewData(
                    popupImage: popupImage,
                    popupTitle: popupData.popupTitle,
                    popupStartDate: popupStartDate.toYYMMDDString(),
                    popupEndDate: popupData.popupEndDate.toYYMMDDString(),
                    popupLocation: popupLocation
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
    func fetchPopupImages() {
        genereateMockData()
    }
}

// MARK: - Public Interface
extension MainSceneViewModel {
    func numbersOfPopup(of category: MainCategory, at index: Int = 0) -> Int {
        switch category {
        case .todayRecommended:
            return carouselPopupImage.count
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
    ) -> PopupPreviewData? {
        let popupData: PopupPreview

        switch category {
        case .todayRecommended:
            popupData = carouselPopupImage[index]
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

    func provideUserInterestTitle(sectionOfInterest: Int) -> String {
        return userInterestPopup[sectionOfInterest].interestCategory.rawValue
    }
}

// MARK: - Implement MainCarouselDataSource
extension MainSceneViewModel {
    func numbersOfCarouselImage() -> Int {
        return numbersOfPopup(of: .todayRecommended)
    }

    func provideCarouselImage(at index: Int) -> PopupPreviewData? {
        providePopupPreviewData(of: .todayRecommended, at: index)
    }
}

// MARK: - Mocking
extension MainSceneViewModel {
    private func genereateMockData() {
        let calendar = Calendar.current
        let today = Date()
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) else { return }
        let image = UIImage(resource: .carousel)

        if let imageData = image.jpegData(compressionQuality: 1.0) {
            let popupPreview = PopupPreview(popupImage: imageData, popupTitle: "찜", popupEndDate: tomorrow)
            let interestPreview = PopupPreview(
                popupImage: imageData,
                popupTitle: "아트아트아트아트아트아트아트아트아트아트아트",
                popupEndDate: tomorrow
            )
            let interestPreview2 = PopupPreview(
                popupImage: imageData,
                popupTitle: "뷰티",
                popupEndDate: tomorrow
            )
            let interestPreview3 = PopupPreview(
                popupImage: imageData,
                popupTitle: "셀럽",
                popupEndDate: tomorrow
            )
            let artPreview = UserInterestPopup(
                interestCategory: .art,
                popups: [interestPreview, interestPreview, interestPreview]
            )
            let beautyPreview = UserInterestPopup(
                interestCategory: .beauty,
                popups: [interestPreview2, interestPreview2, interestPreview2]
            )
            let celebPreview = UserInterestPopup(
                interestCategory: .celebrity,
                popups: [interestPreview3, interestPreview3, interestPreview3]
            )
            let closingSoonPreview = PopupPreview(
                popupImage: imageData,
                popupTitle: "흰둥이흰둥이흰둥이흰둥이흰둥이",
                popupEndDate: Date(),
                popupStartDate: tomorrow,
                popupLocation: "부산광역시 남구 용소로 1번길"
            )

            let closingSoonPreview2 = PopupPreview(
                popupImage: imageData,
                popupTitle: "흰둥이",
                popupEndDate: Date(),
                popupStartDate: tomorrow,
                popupLocation: "부산광역시 남구 용소로 1번길"
            )

            for _ in 0..<5 {
                carouselPopupImage.append(popupPreview)
                userPickPopup.append(popupPreview)
            }
            closingSoonPopup.append(closingSoonPreview)
            closingSoonPopup.append(closingSoonPreview2)
            closingSoonPopup.append(closingSoonPreview)
            closingSoonPopup.append(closingSoonPreview)
            closingSoonPopup.append(closingSoonPreview)

            userInterestPopup.append(artPreview)
            userInterestPopup.append(beautyPreview)
            userInterestPopup.append(celebPreview)
        }
    }
}

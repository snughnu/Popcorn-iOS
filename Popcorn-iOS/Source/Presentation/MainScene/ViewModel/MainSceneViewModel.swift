//
//  MainSceneViewModel.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/17/24.
//

import Foundation

enum MainCategory {
    case userPick
    case userInterest
    case closingSoon
}

struct PopupPreviewData {
    let popupImageUrl: String
    let popupTitle: String?
    let popupStartDate: String?
    let popupEndDate: String?
    let popupLocation: String?
    let popupDDay: String?
    let isPick: Bool?

    init(
        popupImageUrl: String,
        popupTitle: String? = nil,
        popupStartDate: String? = nil,
        popupEndDate: String? = nil,
        popupLocation: String? = nil,
        popupDDay: String? = nil,
        isPick: Bool? = nil
    ) {
        self.popupImageUrl = popupImageUrl
        self.popupTitle = popupTitle
        self.popupStartDate = popupStartDate
        self.popupEndDate = popupEndDate
        self.popupLocation = popupLocation
        self.popupDDay = popupDDay
        self.isPick = isPick
    }
}

struct UserInterestPopupViewData {
    let interestCategory: InterestCategory
    let popups: [PopupPreviewData]
}

final class MainSceneViewModel: MainCarouselViewModelProtocol {
    private let imageFetchUseCase: ImageFetchUseCase

    // 프로토콜 멤버의 접근제어는 모두 동일한데, 구현체에서 얘를 private으로 설정하니 프로토콜에서 정의된 접근제어자와 일치하지 않는다는 에러 발생..
    // 그래서 internal로 냅뒀습니다..
    var carouselPopupImageUrl: [String] = [] {
        didSet {
            carouselImagePublisher?()
        }
    }

    private var userPickPopup: [PopupPreviewData] = [] {
        didSet {
            userPickPopupPublisher?()
        }
    }

    private var userInterestPopup: [UserInterestPopupViewData] = [] {
        didSet {
            userInterestPopupPublisher?()
        }
    }

    private var closingSoonPopup: [PopupPreviewData] = [] {
        didSet {
            userInterestPopupPublisher?()
        }
    }

    // MARK: - Output
    var carouselImagePublisher: (() -> Void)?
    var userPickPopupPublisher: (() -> Void)?
    var userInterestPopupPublisher: (() -> Void)?
    var closingSoonPopupPublisher: (() -> Void)?

    init(imageFetchUseCase: ImageFetchUseCase = ImageFetchUseCase()) {
        self.imageFetchUseCase = imageFetchUseCase
    }

    private func preparePopupPreview(
        of category: MainCategory,
        popupData: PopupPreviewData
    ) -> PopupPreviewData? {
        if category == .userInterest || category == .userPick {
            if let dDay = popupData.popupDDay {
                return PopupPreviewData(
                    popupImageUrl: popupData.popupImageUrl,
                    popupTitle: popupData.popupTitle,
                    popupDDay: "D-\(dDay)"
                )
            }
        }
        else if category == .closingSoon,
                let popupStartDate = popupData.popupStartDate,
                let popupLocation = popupData.popupLocation {
            return PopupPreviewData(
                popupImageUrl: popupData.popupImageUrl,
                popupTitle: popupData.popupTitle,
                popupStartDate: popupStartDate,
                popupEndDate: popupData.popupEndDate,
                popupLocation: popupLocation
            )
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

    func fetchImage(url: String, completion: @escaping (Result<Data, ImageFetchError>) -> Void) {
        guard let url = URL(string: url) else { return }
        imageFetchUseCase.fetchImage(url: url, completion: completion)
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
        let popupData: PopupPreviewData

        switch category {
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
        return carouselPopupImageUrl.count
    }

    func provideCarouselImage() -> [String] {
        return carouselPopupImageUrl
    }
}

// MARK: - Mocking
extension MainSceneViewModel {
    private func genereateMockData() {
    }
}

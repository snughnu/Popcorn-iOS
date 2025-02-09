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

struct PopupPreviewViewData {
    let popupId: Int
    let popupImageUrl: String?
    let popupTitle: String?
    let popupPeriod: String?
    let popupLocation: String?
    let popupDDay: String?

    static let placeholder = PopupPreviewViewData(
        popupId: -1,
        popupImageUrl: nil,
        popupTitle: "팝콘 팝업스토어",
        popupPeriod: "00.00.00~00.00.00",
        popupLocation: "팝콘 팝업스토어",
        popupDDay: "D-0"
    )

    init(
        popupId: Int,
        popupImageUrl: String?,
        popupTitle: String? = nil,
        popupPeriod: String? = nil,
        popupLocation: String? = nil,
        popupDDay: String? = nil
    ) {
        self.popupId = popupId
        self.popupImageUrl = popupImageUrl
        self.popupTitle = popupTitle
        self.popupPeriod = popupPeriod
        self.popupLocation = popupLocation
        self.popupDDay = popupDDay
    }
}

struct UserInterestPopupViewData {
    let interestCategory: String
    let popups: [PopupPreviewViewData]
}

final class MainSceneViewModel: MainCarouselViewModelProtocol {
    private let fetchPopupListUseCase: FetchPopupListUseCaseProtocol
    private let imageFetchUseCase: ImageFetchUseCase

    // 프로토콜 멤버의 접근제어는 모두 동일한데, 구현체에서 얘를 private으로 설정하니 프로토콜에서 정의된 접근제어자와 일치하지 않는다는 에러 발생..
    // 그래서 internal로 냅뒀습니다..
    var carouselPopupImageUrls: [String] = [] {
        didSet {
            carouselImagePublisher?()
        }
    }

    private var userPickPopup: [PopupPreviewViewData] = [] {
        didSet {
            userPickPopupPublisher?()
        }
    }

    private var userInterestPopup: [UserInterestPopupViewData] = [] {
        didSet {
            userInterestPopupPublisher?()
        }
    }

    private var closingSoonPopup: [PopupPreviewViewData] = [] {
        didSet {
            userInterestPopupPublisher?()
        }
    }

    // MARK: - Output
    var carouselImagePublisher: (() -> Void)?
    var userPickPopupPublisher: (() -> Void)?
    var userInterestPopupPublisher: (() -> Void)?
    var closingSoonPopupPublisher: (() -> Void)?
    var fetchPopupImagesErrorPublisher: (() -> Void)?

    init(
        fetchPopupListUseCase: FetchPopupListUseCaseProtocol = FetchPopupListUseCase(),
        imageFetchUseCase: ImageFetchUseCase = ImageFetchUseCase()
    ) {
        self.imageFetchUseCase = imageFetchUseCase
        self.fetchPopupListUseCase = fetchPopupListUseCase
    }

    private func calculateDDay(from dueDate: Date) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let due = calendar.startOfDay(for: dueDate)
        let components = calendar.dateComponents([.day], from: today, to: due).day ?? 0
        return String(components)
    }

    func fetchImage(url: String, completion: @escaping (Result<Data, ImageFetchError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        imageFetchUseCase.fetchImage(url: url, completion: completion)
    }
}

// MARK: - Input
extension MainSceneViewModel {
    func fetchPopupImages() {
        genereateMockData()
    }

    func fetchPopupList() {
        fetchPopupListUseCase.fetchPopupMainList { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let popupMainList):
                self.handleFetchPopupList(popupMainList)
            case .failure:
                self.showPlaceholderData()
            }
        }
    }

    private func convertToViewModelData(
        of category: MainCategory,
        popupData: PopupPreview
    ) -> PopupPreviewViewData? {
        if category == .userInterest || category == .userPick {
            let dDayDate = calculateDDay(from: popupData.popupEndDate)

            return PopupPreviewViewData(
                popupId: popupData.popupId,
                popupImageUrl: popupData.popupImageUrl,
                popupTitle: popupData.popupTitle,
                popupDDay: "D-\(dDayDate)"
            )
        } else if category == .closingSoon,
                  let popupStartDate = popupData.popupStartDate,
                  let location = popupData.popupLocation {
            let startDate = PopupDateFormatter.convertToString(date: popupStartDate)
            let endDate = PopupDateFormatter.convertToString(date: popupData.popupEndDate)
            return PopupPreviewViewData(
                popupId: popupData.popupId,
                popupImageUrl: popupData.popupImageUrl,
                popupTitle: popupData.popupTitle,
                popupPeriod: "\(startDate)~\(endDate)",
                popupLocation: location
            )
        }
        return nil
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
    ) -> PopupPreviewViewData? {
        switch category {
        case .userPick:
            return userPickPopup[index]
        case .userInterest:
            return userInterestPopup[sectionOfInterest].popups[index]
        case .closingSoon:
            return closingSoonPopup[index]
        }
    }

    func provideUserInterestTitle(sectionOfInterest: Int) -> String {
        return userInterestPopup[sectionOfInterest].interestCategory
    }
}

// MARK: - Handling Input
extension MainSceneViewModel {
    private func handleFetchPopupList(_ popupMainList: PopupMainList) {
        self.carouselPopupImageUrls = popupMainList.recommandedPopups

        self.userPickPopup = popupMainList.userPickPopups.compactMap {
            self.convertToViewModelData(of: .userPick, popupData: $0)
        }

        self.userInterestPopup = popupMainList.userInterestPopup
            .map { category in
                let popups = category.popups.compactMap {
                    self.convertToViewModelData(of: .userInterest, popupData: $0)
                }
                return UserInterestPopupViewData(interestCategory: category.interestCategory.rawValue, popups: popups)
            }
            .sorted { $0.interestCategory < $1.interestCategory }

        self.closingSoonPopup = popupMainList.closingSoonPopup.compactMap {
            self.convertToViewModelData(of: .closingSoon, popupData: $0)
        }
    }

    private func showPlaceholderData() {
        self.carouselPopupImageUrls = []
        self.userPickPopup = [PopupPreviewViewData.placeholder]
        self.userInterestPopup = [
            UserInterestPopupViewData(interestCategory: "관심사", popups: [PopupPreviewViewData.placeholder])
        ]
        self.closingSoonPopup = [PopupPreviewViewData.placeholder]
    }
}

// MARK: - Implement MainCarouselDataSource
extension MainSceneViewModel {
    func numbersOfCarouselImage() -> Int {
        return carouselPopupImageUrls.count
    }

    func provideCarouselImage() -> [String] {
        return carouselPopupImageUrls
    }
}

// MARK: - Mocking
extension MainSceneViewModel {
    private func genereateMockData() {
    }
}

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

final class MainSceneViewModel: MainCarouselViewModelProtocol {
    private let fetchPopupListUseCase: FetchPopupListUseCaseProtocol
    private let imageFetchUseCase: ImageFetchUseCase

    private var carouselPopupImageUrls: [String] = []
    private var userPickPopup: [PopupPreviewViewData] = []
    private var userInterestPopup: [UserInterestPopupViewData] = []
    private var closingSoonPopup: [PopupPreviewViewData] = []

    // MARK: - Output
    var carouselImagePublisher: (() -> Void)?
    var fetchPopupDataPublisher: (() -> Void)?
    var fetchPopupImagesErrorPublisher: (() -> Void)?

    init(
        fetchPopupListUseCase: FetchPopupListUseCaseProtocol = FetchPopupListUseCase(),
        imageFetchUseCase: ImageFetchUseCase = ImageFetchUseCase()
    ) {
        self.imageFetchUseCase = imageFetchUseCase
        self.fetchPopupListUseCase = fetchPopupListUseCase
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
                fetchPopupDataPublisher?()
            case .failure:
                self.showPlaceholderData()
            }
        }
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
            PopupPreviewViewData(from: $0)
        }

        self.userInterestPopup = popupMainList.userInterestPopup
            .map { category in
                return UserInterestPopupViewData(
                    interestCategory: category.interestCategory.rawValue,
                    popups: category.popups.compactMap { PopupPreviewViewData(from: $0) }
                )
            }
            .sorted { $0.interestCategory < $1.interestCategory }

        self.closingSoonPopup = popupMainList.closingSoonPopup.compactMap {
            PopupPreviewViewData(from: $0)
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

// MARK: - View Model
struct PopupPreviewViewData {
    let popupId: Int
    let popupImageUrl: String
    let popupTitle: String
    let popupPeriod: String?
    let popupDDay: String?
    let popupLocation: String?

    static let placeholder = PopupPreviewViewData(
        from: PopupPreview(
            popupId: -1,
            popupImageUrl: "",
            popupTitle: "팝콘 팝업스토어",
            popupEndDate: Date(),
            popupStartDate: Date(),
            popupLocation: "팝콘시 팝콘구 팝콘로 0번길"
        )
    )

    init(from popupPreview: PopupPreview) {
        self.popupId = popupPreview.popupId
        self.popupImageUrl = popupPreview.popupImageUrl
        self.popupTitle = popupPreview.popupTitle
        self.popupLocation = popupPreview.popupLocation
        self.popupDDay = "D-\(PopupDateFormatter.calculateDDay(from: popupPreview.popupEndDate))"

        self.popupPeriod = popupPreview.popupStartDate.map { startDate in
            let startDateString = PopupDateFormatter.convertToString(date: startDate)
            let endDateString = PopupDateFormatter.convertToString(date: popupPreview.popupEndDate)
            return "\(startDateString)~\(endDateString)"
        }
    }
}

struct UserInterestPopupViewData {
    let interestCategory: String
    let popups: [PopupPreviewViewData]
}

// MARK: - Mocking
extension MainSceneViewModel {
    private func genereateMockData() {
    }
}

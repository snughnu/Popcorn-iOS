//
//  MainSceneViewModel.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/17/24.
//

import Foundation

final class MainSceneViewModel: MainCarouselViewModelProtocol {
    private let fetchPopupListUseCase: FetchPopupListUseCaseProtocol
    private let imageFetchUseCase: ImageFetchUseCase

    private var carouselPopupImageUrls: [PopupPreviewViewData] = []
    private var userPickPopup: [PopupPreviewViewData] = []
    private var userInterestPopup: [UserInterestPopupViewData] = []
    private var closingSoonPopup: [PopupPreviewViewData] = []
    private let mainSceneDataSource: MainSceneDataSource

    // MARK: - Output
    var carouselImagePublisher: (() -> Void)?
    var fetchPopupDataPublisher: (() -> Void)?
    var fetchPopupImagesErrorPublisher: (() -> Void)?

    init(
        fetchPopupListUseCase: FetchPopupListUseCaseProtocol = FetchPopupListUseCase(),
        imageFetchUseCase: ImageFetchUseCase = ImageFetchUseCase(),
        mainSceneDataSource: MainSceneDataSource = MainSceneDataSource()
    ) {
        self.imageFetchUseCase = imageFetchUseCase
        self.fetchPopupListUseCase = fetchPopupListUseCase
        self.mainSceneDataSource = mainSceneDataSource
    }

    func getDataSource() -> MainSceneDataSource {
        return mainSceneDataSource
    }
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
    func fetchMockData() {
        genereateMockData()
        fetchPopupDataPublisher?()
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

    func provideCarouselImageUrl(at indexPath: IndexPath) -> String {
        return mainSceneDataSource.item(at: indexPath).popupImageUrl
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

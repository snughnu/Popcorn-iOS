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

// MARK: - Networking
extension MainSceneViewModel {
    func fetchImage(url: String, completion: @escaping (Result<Data, ImageFetchError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        imageFetchUseCase.fetchImage(url: url, completion: completion)
    }

    func fetchPopupList() {
        fetchPopupListUseCase.fetchPopupMainList { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let popupMainList):
                self.mainSceneDataSource.updateData(popupMainList)
                fetchPopupDataPublisher?()
            case .failure:
                self.mainSceneDataSource.showPlaceholderData()
            }
        }
    }

    func fetchMockData() {
        mainSceneDataSource.genereateMockData()
        fetchPopupDataPublisher?()
    }
}

// MARK: - Implement MainCarouselDataSource
extension MainSceneViewModel {
    func numbersOfCarouselImage() -> Int {
        return mainSceneDataSource.numbersOfPopup(of: .todayRecommend)
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
            let startDateString = PopupDateFormatter.formattedPopupStoreDate(from: startDate)
            let endDateString = PopupDateFormatter.formattedPopupStoreDate(from: popupPreview.popupEndDate)
            return "\(startDateString)~\(endDateString)"
        }
    }
}

struct UserInterestPopupViewData {
    let interestCategory: String
    let popups: [PopupPreviewViewData]
}

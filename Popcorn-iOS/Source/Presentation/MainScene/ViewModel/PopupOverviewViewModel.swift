//
//  PopupOverviewViewModel.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 3/13/25.
//

import Foundation

final class PopupOverviewViewModel {
    private let popupFetchUseCase: PopupFetchListUseCaseProtocol
    private let imageFetchUseCase: ImageFetchUseCaseProtocol
    private let category: PopupSectionCategory
    private var page = 1
    private var popupOverview = [PopupOverviewViewData]() {
        didSet {
            popupOverviewPublisher?()
        }
    }

    // MARK: - Output
    var popupOverviewPublisher: (() -> Void)?

    init(
        category: PopupSectionCategory,
        popupFetchUseCase: PopupFetchListUseCaseProtocol,
        imageFetchUseCase: ImageFetchUseCaseProtocol = DIContainer.shared.resolve(ImageFetchUseCaseProtocol.self)
    ) {
        self.popupFetchUseCase = popupFetchUseCase
        self.imageFetchUseCase = imageFetchUseCase
        self.category = category
    }
}

// MARK: - Public Interface
extension PopupOverviewViewModel {
    func numberOfItems() -> Int {
        return popupOverview.count
    }

    func item(at index: Int) -> PopupOverviewViewData {
        return popupOverview[index]
    }

    func getCategory() -> PopupSectionCategory {
        return category
    }
}

// MARK: - Networking
extension PopupOverviewViewModel {
    func fetchImage(url: String, completion: @escaping (Result<Data, ImageFetchError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        imageFetchUseCase.fetchImage(url: url, completion: completion)
    }

    func fetchPopupOverview() {
        print("hi")
        popupFetchUseCase.fetchPopupOverview(category: category, page: page) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let popupOverview):
                if self.page == 1 {
                    self.popupOverview = popupOverview.map { PopupOverviewViewData(from: $0) }
                } else {
                    self.popupOverview += popupOverview.map { PopupOverviewViewData(from: $0) }
                }
            case .failure:
                self.popupOverview = [PopupOverviewViewData.placeHolder]
            }
        }
    }
}

// MARK: - Input
extension PopupOverviewViewModel {
    /// 선택한 셀의 팝업스토어 Id를 반환
    func didTapPopup(_ indexPath: IndexPath) -> Int {
        let popupId = popupOverview[indexPath.row].popupId
        return popupId
    }

    func fetchMore() {
        // MARK: - 서버 구현 완료 후 주석 풀기
//        page += 1
//        fetchPopupOverview()
    }
}

struct PopupOverviewViewData {
    let popupId: Int
    let popupImageUrl: String
    let popupTitle: String
    let popupPeriod: String
    let popupAddress: String

    static let placeHolder = PopupOverviewViewData(
        from: PopupOverview(
            id: -1,
            imageUrl: "",
            title: "팝콘팝업스토어",
            startDate: Date(),
            endDate: Date(),
            address: "팝콘시 팝콘구 팝콘로 0번길"
        )
    )

    init(from entity: PopupOverview) {
        let startDate = PopupDateFormatter.formattedPopupStoreDate(from: entity.startDate)
        let endDate = PopupDateFormatter.formattedPopupStoreDate(from: entity.endDate)

        popupId = entity.id
        popupImageUrl = entity.imageUrl
        popupTitle = entity.title
        popupPeriod = startDate + "~" + endDate
        popupAddress = entity.address
    }
}

// MARK: - Mocking
extension PopupOverviewViewModel {
    func generateMockData() {
        let overview = MainSceneMockDataConstant.generatePopupOverviewData()

        popupOverview = overview.map { PopupOverviewViewData(from: $0) }
    }
}

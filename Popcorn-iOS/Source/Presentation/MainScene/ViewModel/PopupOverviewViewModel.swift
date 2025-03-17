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
        imageFetchUseCase: ImageFetchUseCaseProtocol
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
        page += 1
        fetchPopupOverview()
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
            popupId: -1,
            popupImageUrl: "",
            popupTitle: "팝콘팝업스토어",
            startDate: Date(),
            endDate: Date(),
            address: "팝콘시 팝콘구 팝콘로 0번길"
        )
    )

    init(from entity: PopupOverview) {
        let startDate = PopupDateFormatter.formattedPopupStoreDate(from: entity.startDate)
        let endDate = PopupDateFormatter.formattedPopupStoreDate(from: entity.endDate)

        popupId = entity.popupId
        popupImageUrl = entity.popupImageUrl
        popupTitle = entity.popupTitle
        popupPeriod = startDate + "~" + endDate
        popupAddress = entity.address
    }
}

// MARK: - Mocking
extension PopupOverviewViewModel {
    func generateMockData() {
        let chiImageUrl = "https://gist.github.com/user-attachments/assets/a45d0e3f-b1a0-4675-b0b0-82cb7f9e4721"
        let akiriImageUrl = "https://gist.github.com/user-attachments/assets/660ccd91-fd4a-4d1b-a98d-9c3b6d5bc34f"
        let pinguImageUrl = "https://gist.github.com/user-attachments/assets/ffc183ff-4d2e-4f45-b6e6-b602b15b53cc"
        let dragonBallImageUrl = "https://gist.github.com/user-attachments/assets/c5b3f41b-eb6b-41aa-8eec-1bc4c1dff59a"
        let footbalImageUrl = "https://gist.github.com/user-attachments/assets/e6fe6c4e-937f-4156-a6a1-a4232ab4feab"
        let anilaImageUrl = "https://gist.github.com/user-attachments/assets/12289a42-36d3-4f65-901e-632e7529acfa"

        let anilaData = PopupOverviewViewData(
            from: PopupOverview(
                popupId: -1,
                popupImageUrl: anilaImageUrl,
                popupTitle: "핑구 팝업스토어",
                startDate: Date(),
                endDate: Date().addingTimeInterval(3600 * 24 * 7),
                address: "서울특별시 영등포구 여의대로 108 파크원 지하 1층"
            )
        )

        let chiData = PopupOverviewViewData(
            from: PopupOverview(
                popupId: -1,
                popupImageUrl: chiImageUrl,
                popupTitle: "핑구 팝업스토어",
                startDate: Date(),
                endDate: Date().addingTimeInterval(3600 * 24 * 7),
                address: "서울특별시 영등포구 여의대로 108 파크원 지하 1층"
            )
        )

        let akiriData = PopupOverviewViewData(
            from: PopupOverview(
                popupId: -1,
                popupImageUrl: akiriImageUrl,
                popupTitle: "핑구 팝업스토어",
                startDate: Date(),
                endDate: Date().addingTimeInterval(3600 * 24 * 7),
                address: "서울특별시 영등포구 여의대로 108 파크원 지하 1층"
            )
        )

        let pinguData = PopupOverviewViewData(
            from: PopupOverview(
                popupId: -1,
                popupImageUrl: pinguImageUrl,
                popupTitle: "핑구 팝업스토어",
                startDate: Date(),
                endDate: Date().addingTimeInterval(3600 * 24 * 7),
                address: "서울특별시 영등포구 여의대로 108 파크원 지하 1층"
            )
        )

        let dragonBallData = PopupOverviewViewData(
            from: PopupOverview(
                popupId: -1,
                popupImageUrl: dragonBallImageUrl,
                popupTitle: "핑구 팝업스토어",
                startDate: Date(),
                endDate: Date().addingTimeInterval(3600 * 24 * 7),
                address: "서울특별시 영등포구 여의대로 108 파크원 지하 1층"
            )
        )

        let footBallData = PopupOverviewViewData(
            from: PopupOverview(
                popupId: -1,
                popupImageUrl: footbalImageUrl,
                popupTitle: "핑구 팝업스토어",
                startDate: Date(),
                endDate: Date().addingTimeInterval(3600 * 24 * 7),
                address: "서울특별시 영등포구 여의대로 108 파크원 지하 1층"
            )
        )

        popupOverview = [anilaData, chiData, akiriData, pinguData, dragonBallData, footBallData]
    }
}

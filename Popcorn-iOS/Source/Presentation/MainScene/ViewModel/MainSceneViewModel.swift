//
//  MainSceneViewModel.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/17/24.
//

import Foundation

enum MainSceneSection: Equatable {
    case userPick
    case userInterest(index: Int)
    case closingSoon
}

final class MainSceneViewModel: MainCarouselViewModelProtocol {
    private let popupFetchListUseCase: PopupFetchListUseCaseProtocol
    private let imageFetchUseCase: ImageFetchUseCaseProtocol
    private let mainSceneDataSource: MainSceneDataSource

    /// 오늘의 추천, 찜 목록, 관심사, 지금 놓치면 안될 팝업 섹션들 중 현재 화면에 표시될 섹션을 담는 배열
    private(set) var sections = [MainSceneSection]()
    private var hasNextPage = true
    private var page = 1

    // MARK: - Output
    var carouselImagePublisher: (() -> Void)?
    var fetchPopupDataPublisher: (() -> Void)?
    var fetchPopupImagesErrorPublisher: (() -> Void)?

    init(
        popupFetchListUseCase: PopupFetchListUseCaseProtocol,
        imageFetchUseCase: ImageFetchUseCaseProtocol,
        mainSceneDataSource: MainSceneDataSource = MainSceneDataSource()
    ) {
        self.imageFetchUseCase = imageFetchUseCase
        self.popupFetchListUseCase = popupFetchListUseCase
        self.mainSceneDataSource = mainSceneDataSource
    }

    private func updateSections() {
        sections = buildSections()
    }

    private func buildSections() -> [MainSceneSection] {
        var sections = [MainSceneSection]()
        if mainSceneDataSource.numberOfPopups(in: .userPick) > 0 {
            sections.append(.userPick)
        }

        let interestCount = mainSceneDataSource.numbersOfInterest()
        sections += (0..<interestCount).map { .userInterest(index: $0) }

        sections.append(.closingSoon)

        return sections
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
        popupFetchListUseCase.fetchPopupMainList { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                let popupMainList = response.data
                self.hasNextPage = response.hasNextPage
                self.mainSceneDataSource.updateData(popupMainList)
                self.updateSections()
                fetchPopupDataPublisher?()
            case .failure(let error):
                print(error)
//                self.mainSceneDataSource.showPlaceholderData()
            }
        }
    }

    /// 지금 놓치면 안 될 팝업스토어 페이지네이션 시 사용
    func fetchClosingSoonPopup(page: Int) {
        popupFetchListUseCase.fetchClosingSoongPopups(page: page) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let response):
                self.page += 1
                let closingSoonPopups = response.data
                self.hasNextPage = response.hasNextPage
                self.mainSceneDataSource.updateClosingSoonPopup(closingSoonPopups)
            case .failure:
                mainSceneDataSource.updateClosingSoonPopup([])
            }
        }
    }

    func fetchMockData() {
//        mainSceneDataSource.genereateMockData()
        fetchPopupDataPublisher?()
    }
}

// MARK: - DataSource
extension MainSceneViewModel {
    func numberOfPopups(in section: MainSceneSection) -> Int {
        return mainSceneDataSource.numberOfPopups(in: section)
    }

    func numberOfInterest() -> Int {
        return mainSceneDataSource.numbersOfInterest()
    }

    func getPopup(for section: MainSceneSection, at index: Int) -> PopupPreviewViewData {
        guard let popup = mainSceneDataSource.popup(for: section, item: index) else {
            return PopupPreviewViewData.placeholder
        }

        return PopupPreviewViewData(from: popup)
    }

    func getTodayRecommendPopupId(at index: Int) -> Int {
        // TODO: - -1 반환 대신 nil 리턴, detailViewController 생성자에서 popupId가 nil일 때 처리.
        return mainSceneDataSource.getTodayRecommend(item: index)?.popupId ?? -1
    }

    func getInterestCategoryTitle(for section: MainSceneSection) -> String {
        mainSceneDataSource.interestCategoryTitle(for: section) ?? ""
    }
}

// MARK: - Implement MainCarouselDataSource
extension MainSceneViewModel {
    func numbersOfCarouselImage() -> Int {
        return mainSceneDataSource.numberOfTodayRecommend()
    }

    func provideCarouselImageUrl(at indexPath: IndexPath) -> String {
        return mainSceneDataSource.getTodayRecommend(item: indexPath.item)?.popupImageUrl ?? ""
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

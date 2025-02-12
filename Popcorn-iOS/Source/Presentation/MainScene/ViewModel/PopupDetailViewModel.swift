//
//  PopupDetailViewModel.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 1/5/25.
//

import Foundation

final class PopupDetailViewModel: MainCarouselViewModelProtocol {
    private let imageFetchUseCase: ImageFetchUseCaseProtocol

    private var carouselPopupImageUrls: [String] = []
    private var popupMainInformation: PopupMainInformationViewData?
    private var popupDetailInformation: PopupDetailInformationViewData?
    private var popupRating: PopupRatingViewData?
    private var popupReviews: [PopupReviewViewData] = []

    // MARK: - Output
    var carouselImagePublisher: (() -> Void)?
    var popupInformationPublisher: (() -> Void)?
    var popupReviewPublisher: (() -> Void)?

    init(imageFetchUseCase: ImageFetchUseCaseProtocol = ImageFetchUseCase()) {
        self.imageFetchUseCase = imageFetchUseCase
    }

    private func bindPopupDetailInformation(_ data: PopupInformation) {
        carouselPopupImageUrls = data.popupImagesUrl
        popupMainInformation = PopupMainInformationViewData(from: data.mainInformation)
        popupDetailInformation = PopupDetailInformationViewData(from: data.detailInformation)
        popupRating = PopupRatingViewData(from: data.totalReview)
        popupReviews = data.totalReview.review.map { PopupReviewViewData(from: $0) }
    }

    func fetchImage(url: String, completion: @escaping (Result<Data, ImageFetchError>) -> Void) {
        guard let url = URL(string: url) else { return }
        imageFetchUseCase.fetchImage(url: url, completion: completion)
    }
}

// MARK: - Input
extension PopupDetailViewModel {
    func fetchPopupInformation() {
    }

    func generateMockData() {
    }
}

// MARK: - Public Interface
extension PopupDetailViewModel {
    func numbersOfReviews() -> Int {
        return popupReviews.count
    }

    func provideMainInformationData() -> PopupMainInformationViewData {
        guard let popupMainInformation else { return PopupMainInformationViewData.placeholder }
        return popupMainInformation
    }

    func provideDetailInformationData() -> PopupDetailInformationViewData {
        guard let popupDetailInformation else { return PopupDetailInformationViewData.placeholder }
        return popupDetailInformation
    }

    /// starBreakDown의 value 중 최댓값 반환. 단, value가 같을 경우 key가 가장 큰 원소의 key를 반환
    func provideRatingData() -> (PopupRatingViewData, Int) {
        guard let popupRating else { return (PopupRatingViewData.placeholder, 0) }
        let maximumIndex = popupRating.starBreakDown.sorted {
            $0.value == $1.value ? $0.key > $1.key : $0.value > $1.value
        }.first?.key ?? 4

        return (popupRating, maximumIndex)
    }

    func provideReviewData(at index: Int) -> PopupReviewViewData {
        return popupReviews[index]
    }
}

// MARK: - Implement MainCarouselViewModelProtocol
extension PopupDetailViewModel {
    func provideCarouselImageUrl(at indexPath: IndexPath) -> String {
        return carouselPopupImageUrls[indexPath.row]
    }

    func numbersOfCarouselImage() -> Int {
        return carouselPopupImageUrls.count
    }
}

// MARK: - View Model
struct PopupMainInformationViewData {
    let popupTitle: String
    let popupPeriod: String
    let isUserPick: Bool
    let hashTags: [String]

    static let placeholder = PopupMainInformationViewData(
        from: PopupMainInformation(
            popupTitle: "팝콘 팝업스토어",
            startDate: Date(),
            endDate: Date(),
            isUserPick: false,
            hashTags: []
        )
    )

    init(from entity: PopupMainInformation) {
        let startDateString = PopupDateFormatter.formattedPopupStoreDate(from: entity.startDate)
        let endDateString = PopupDateFormatter.formattedPopupStoreDate(from: entity.endDate)

        self.popupTitle = entity.popupTitle
        self.isUserPick = entity.isUserPick
        self.hashTags = entity.hashTags ?? []
        self.popupPeriod = "\(startDateString)~\(endDateString)"
    }
}

struct PopupDetailInformationViewData {
    let address: String
    let officialLink: String
    let buisinessHours: String
    let introduce: String

    static let placeholder = PopupDetailInformationViewData(
        from: PopupDetailInformation(
            address: "",
            officialLink: "",
            businesesHours: "",
            introduce: ""
        )
    )

    init(from entity: PopupDetailInformation) {
        self.address = entity.address
        self.officialLink = entity.officialLink
        self.buisinessHours = entity.businesesHours
        self.introduce = entity.introduce
    }
}

struct PopupRatingViewData {
    let totalRatingCount: Int
    let averageRating: Float
    let starBreakDown: [Int: Int]

    static let placeholder = PopupRatingViewData(
        from: PopupTotalReview(
            averageRating: 0,
            starBreakDown: [0: 0, 1: 0, 2: 0, 3: 0, 4: 0],
            review: [])
    )

    init(from entity: PopupTotalReview) {
        self.totalRatingCount = entity.review.count
        self.averageRating = entity.averageRating
        self.starBreakDown = entity.starBreakDown
    }
}

struct PopupReviewViewData {
    let profileImageUrl: String?
    let nickname: String
    let rating: Float
    let reviewDate: String
    let imagesUrl: [String]?
    let reviewText: String

    static let placeholder = PopupReviewViewData(
        from: PopupReview(
            profileImageUrl: nil,
            nickName: "사용자",
            reviewRating: 0,
            reviewDate: DateFormatter.apiDateFormatter.date(from: "1900-01-01 00:00:00")!,
            reviewImagesUrl: nil,
            reviewText: ""
        )
    )

    init(from entity: PopupReview) {
        self.profileImageUrl = entity.profileImageUrl
        self.nickname = entity.nickName
        self.rating = entity.reviewRating
        self.reviewDate = PopupDateFormatter.formattedReviewDate(from: entity.reviewDate)
        self.imagesUrl = entity.reviewImagesUrl
        self.reviewText = entity.reviewText
    }
}

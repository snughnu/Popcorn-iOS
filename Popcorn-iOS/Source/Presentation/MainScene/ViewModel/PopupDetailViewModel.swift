//
//  PopupDetailViewModel.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 1/5/25.
//

import Foundation

final class PopupDetailViewModel: MainCarouselViewModelProtocol {
    private let imageFetchUseCase: ImageFetchUseCaseProtocol
    private let popupDetailDataSource: PopupDetailDataSource

    // MARK: - Output
    var carouselImagePublisher: (() -> Void)?
    var popupInformationPublisher: (() -> Void)?
    var popupReviewPublisher: (() -> Void)?

    init(imageFetchUseCase: ImageFetchUseCaseProtocol = ImageFetchUseCase(),
         popupDetailDataSource: PopupDetailDataSource = PopupDetailDataSource()
    ) {
        self.imageFetchUseCase = imageFetchUseCase
        self.popupDetailDataSource = popupDetailDataSource
    }

    func getDataSource() -> PopupDetailDataSource {
        return popupDetailDataSource
    }
}

// MARK: - Networking
extension PopupDetailViewModel {
    func fetchImage(url: String, completion: @escaping (Result<Data, ImageFetchError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        imageFetchUseCase.fetchImage(url: url, completion: completion)
    }

    func fetchPopupInformation() {
        // 네트워킹 코드... 
        popupInformationPublisher?()
    }

    func generateMockData() {
        getDataSource().generateMockData()
    }
}

// MARK: - Implement MainCarouselViewModelProtocol
extension PopupDetailViewModel {
    func numbersOfCarouselImage() -> Int {
        return popupDetailDataSource.numberOfCarouseImage()
    }

    func provideCarouselImageUrl(at indexPath: IndexPath) -> String {
        return popupDetailDataSource.popupImageItem(at: indexPath)
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

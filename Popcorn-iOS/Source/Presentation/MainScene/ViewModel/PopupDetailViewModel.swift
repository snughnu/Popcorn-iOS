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
        // dataSource.updateData()
        popupInformationPublisher?()
    }

    func fetchPopupReview() {
        // 네트워킹 코드...
        // dataSource.updateData()
        popupReviewPublisher?()
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
            popupId: -1,
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
            introduce: "",
            reservationUrl: ""
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
    let ratingDistribution: [RatingDistribution: Int]

    static let placeholder = PopupRatingViewData(
        from: PopupRatingDistribution(
            averageRating: 0,
            ratingDistribution: [.oneStar: 0, .twoStars: 0, .threeStars: 0, .fourStars: 0, .fiveStars: 0]
        )
    )

    init(from entity: PopupRatingDistribution) {
        self.totalRatingCount = entity.ratingDistribution.values.reduce(0, +)
        self.averageRating = entity.averageRating
        self.ratingDistribution = entity.ratingDistribution
    }
}

struct PopupReviewViewData {
    let profileImageUrl: String?
    let nickname: String
    let reviewRating: Float
    let reviewDate: String
    let reviewImagesUrl: [String]?
    let reviewText: String
    let likeCount: Int
    let isLiked: Bool

    static let placeholder = PopupReviewViewData(
        from: PopupReview(
            profileImageUrl: nil,
            nickName: "팝콘이",
            reviewRating: 0,
            reviewDate: DateFormatter.apiDateFormatter.date(from: "1900-01-01 00:00:00")!,
            reviewImagesUrl: nil,
            reviewText: "",
            likeCount: 0,
            isLiked: false
        )
    )

    init(from entity: PopupReview) {
        self.profileImageUrl = entity.profileImageUrl
        self.nickname = entity.nickName
        self.reviewRating = entity.reviewRating
        self.reviewDate = PopupDateFormatter.formattedReviewDate(from: entity.reviewDate)
        self.reviewImagesUrl = entity.reviewImagesUrl
        self.reviewText = entity.reviewText
        self.likeCount = entity.likeCount
        self.isLiked = entity.isLiked
    }
}

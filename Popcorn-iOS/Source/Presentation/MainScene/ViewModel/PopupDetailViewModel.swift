//
//  PopupDetailViewModel.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 1/5/25.
//

import Foundation

struct PopupMainInformationViewData {
    let popupTitle: String
    let popupPeriod: String
    let isUserPick: Bool
    let hashTags: [String]

    init(
        popupTitle: String = "",
        popupPeriod: String = "",
        isUserPick: Bool = false,
        hashTags: [String] = []
    ) {
        self.popupTitle = popupTitle
        self.popupPeriod = popupPeriod
        self.isUserPick = isUserPick
        self.hashTags = hashTags
    }
}

struct PopupDetailInformationViewData {
    let address: String
    let officialLink: String
    let buisinessHours: String
    let introduce: String

    init(
        address: String = "",
        officialLink: String = "",
        buisinessHours: String = "",
        introduce: String = ""
    ) {
        self.address = address
        self.officialLink = officialLink
        self.buisinessHours = buisinessHours
        self.introduce = introduce
    }
}

struct PopupRatingViewData {
    let totalRatingCount: Int
    let averageRating: Float
    let starBreakDown: [Int: Int]

    init(totalRatingCount: Int = 0, averageRating: Float = 0, starBreakDown: [Int: Int] = [:]) {
        self.totalRatingCount = totalRatingCount
        self.averageRating = averageRating
        self.starBreakDown = starBreakDown
    }
}

struct PopupReviewViewData {
    let profileImageUrl: String?
    let nickname: String
    let rating: Float
    let reviewDate: String
    let imagesUrl: [String]?
    let reviewText: String
}

final class PopupDetailViewModel: MainCarouselViewModelProtocol {
    private let imageFetchUseCase: ImageFetchUseCaseProtocol

    var carouselPopupImageUrls: [String] = [] {
        didSet {
            carouselImagePublisher?()
        }
    }

    private var popupMainInformation: PopupMainInformationViewData = PopupMainInformationViewData() {
        didSet {
            popupMainInformationPublisher?()
        }
    }

    private var popupDetailInformation: PopupDetailInformationViewData = PopupDetailInformationViewData() {
        didSet {
            popupDetailInformationPublisher?()
        }
    }

    private var popupRating: PopupRatingViewData = PopupRatingViewData() {
        didSet {
            popupRatingPublisher?()
        }
    }

    private var popupReviews: [PopupReviewViewData] = [] {
        didSet {
            popupReviewsDataPublisher?()
        }
    }

    // MARK: - Output
    var carouselImagePublisher: (() -> Void)?
    var popupMainInformationPublisher: (() -> Void)?
    var popupDetailInformationPublisher: (() -> Void)?
    var popupRatingPublisher: (() -> Void)?
    var popupReviewsDataPublisher: (() -> Void)?

    init(imageFetchUseCase: ImageFetchUseCaseProtocol = ImageFetchUseCase()) {
        self.imageFetchUseCase = imageFetchUseCase
    }

    private func bindPopupDetailInformation(_ data: PopupInformation) {
        let hashTags = data.mainInformation.hashTags ?? []

        carouselPopupImageUrls = data.popupImagesUrl
        
        let startDateString = PopupDateFormatter.formattedPopupStoreDate(from: data.mainInformation.startDate)
        let endDateString = PopupDateFormatter.formattedPopupStoreDate(from: data.mainInformation.endDate)

        popupMainInformation = PopupMainInformationViewData(
            popupTitle: data.mainInformation.popupTitle,
            popupPeriod: "\(startDateString)~\(endDateString)",
            isUserPick: data.mainInformation.isUserPick,
            hashTags: hashTags
        )

        popupDetailInformation = PopupDetailInformationViewData(
            address: data.detailInformation.address,
            officialLink: data.detailInformation.officialLink,
            buisinessHours: data.detailInformation.businesesHours,
            introduce: data.detailInformation.introduce
        )

        popupRating = PopupRatingViewData(
            totalRatingCount: data.totalReview.review.count,
            averageRating: data.totalReview.averageRating,
            starBreakDown: data.totalReview.starBreakDown
        )

        popupReviews = data.totalReview.review.map { review in
            let profileImageUrl = review.profileImageUrl
            let reviewImagesUrls = review.reviewImagesUrl
            return PopupReviewViewData(
                profileImageUrl: profileImageUrl,
                nickname: review.nickName,
                rating: review.reviewRating,
                reviewDate: PopupDateFormatter.formattedReviewDate(from: review.reviewDate),
                imagesUrl: reviewImagesUrls,
                reviewText: review.reviewText
            )
        }
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
        return popupMainInformation
    }

    func provideDetailInformationData() -> PopupDetailInformationViewData {
        return popupDetailInformation
    }

    func provideRatingData() -> (PopupRatingViewData, Int) {
        // starBreakDown의 value 중 최댓값 반환. 단, value가 같을 경우 key가 가장 큰 원소의 key를 반환
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

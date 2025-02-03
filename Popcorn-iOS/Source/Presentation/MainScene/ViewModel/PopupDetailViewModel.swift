//
//  PopupDetailViewModel.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 1/5/25.
//

import UIKit

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
    let profileImage: UIImage
    let nickname: String
    let rating: Float
    let reviewDate: String
    let images: [UIImage]
    let reviewText: String
}

final class PopupDetailViewModel: MainCarouselViewModelProtocol {
    var carouselPopupImage: [UIImage] = [] {
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

    init() {
        // usecase 주입
    }

    private func bindPopupDetailInformation(_ data: PopupInformation) {
        let hashTags = data.mainInformation.hashTags ?? []

        carouselPopupImage = data.popupImages.compactMap { UIImage(data: $0) }

        popupMainInformation = PopupMainInformationViewData(
            popupTitle: data.mainInformation.popupTitle,
            popupPeriod: formatPeriod(start: data.mainInformation.startDate, end: data.mainInformation.endDate),
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
            let profileImage = review.profileImage.flatMap { UIImage(data: $0) } ?? UIImage(resource: .grayCircle)
            let reviewImages = review.reviewImages?.compactMap { UIImage(data: $0) } ?? []
            return PopupReviewViewData(
                profileImage: profileImage,
                nickname: review.nickName,
                rating: review.reviewRating,
                reviewDate: formatDate(review.reviewDate),
                images: reviewImages,
                reviewText: review.reviewText
            )
        }
    }

    private func formatPeriod(start: Date, end: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd"
        return "\(dateFormatter.string(from: start)) - \(dateFormatter.string(from: end))"
    }

    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date)
    }
}

// MARK: - Input
extension PopupDetailViewModel {
    func fetchPopupInformation() {
    }

    func generateMockData() {
        let image1 = UIImage(resource: .carousel)
        let image2 = UIImage(resource: .popup)
        let image3 = UIImage(resource: .checkButtonSelected)
        let imageData1 = image1.jpegData(compressionQuality: 0.3) ?? Data()
        let imageData2 = image2.jpegData(compressionQuality: 0.3) ?? Data()
        let imageData3 = image3.jpegData(compressionQuality: 0.3) ?? Data()

        let reviews = [
            PopupReview(
                profileImage: imageData1, nickName: "팝콘이1", reviewRating: 3.8,
                reviewDate: Date(), reviewImages: [imageData1, imageData2, imageData3], reviewText: "좋아요"
            ),
            PopupReview(
                profileImage: imageData2, nickName: "팝콘이2", reviewRating: 0.0,
                reviewDate: Date(), reviewImages: [], reviewText: "좋아요"
            ),
            PopupReview(
                profileImage: imageData3, nickName: "팝콘이3", reviewRating: 5.0,
                reviewDate: Date(), reviewImages: [imageData2], reviewText: "좋아요"
            )
        ]

        let popupTotalReview = PopupTotalReview(
            averageRating: 2.9, starBreakDown: [0: 1, 1: 0, 2: 1, 3: 0, 4: 1], review: reviews
        )

        let detailInfo = PopupDetailInformation(
            address: "서울특별시 영등포구 여의대로 999 지하1층", officialLink: "www.naver.com",
            businesesHours: "월~목 : 10:30 - 20:00", introduce:
"""
사랑과 감동이 가득하던 핑구 마을부터 핑구 가족들, 그리고 귀여운 굿즈들까지!
핑구 마을 낚시터는 물론 핑구 아빠가 전달해주는 우편함까지 다양한 체험존도 경험해보세요!
핑구는 오는 11월 4일 서울을 시작으로 전국적으로 찾아갈 예정이니 많관부❤
사랑과 감동이 가득하던 핑구 마을부터 핑구 가족들, 그리고 귀여운 굿즈들까지!
핑구 마을 낚시터는 물론 핑구 아빠가 전달해주는 우편함까지 다양한 체험존도 경험해보세요!
핑구는 오는 11월 4일 서울을 시작으로 전국적으로 찾아갈 예정이니 많관부❤
"""
        )

        let mainInfo = PopupMainInformation(
            popupTitle: "핑구 팝업스토어", startDate: Date(timeIntervalSince1970: 100),
            endDate: Date(timeIntervalSince1970: 259200),
            isUserPick: true, hashTags: ["캐릭터", "펭귄", "핑구", "D-5", "굿즈", "더현대서울"]
        )

        let popupInfo = PopupInformation(
            popupImages: [imageData1, imageData2, imageData1], mainInformation: mainInfo,
            detailInformation: detailInfo, totalReview: popupTotalReview
        )

        bindPopupDetailInformation(popupInfo)
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
    func provideCarouselImage() -> [UIImage] {
        return carouselPopupImage
    }

    func numbersOfCarouselImage() -> Int {
        return carouselPopupImage.count
    }
}

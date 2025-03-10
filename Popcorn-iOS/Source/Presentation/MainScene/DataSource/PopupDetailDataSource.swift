//
//  PopupDetailDataSource.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/13/25.
//

import Foundation

final class PopupDetailDataSource {
    private var popupMainInformation: PopupMainInformationViewData?
    private var popupDetailInformation: PopupDetailInformationViewData?
    private var popupRating: PopupRatingViewData?
    private var popupReviews = [PopupReviewViewData]()
}

// MARK: - Input
extension PopupDetailDataSource {
    func updateInformationData(_ data: PopupInformation) {
        popupMainInformation = PopupMainInformationViewData(from: data)
        popupDetailInformation = PopupDetailInformationViewData(from: data)
    }

    func updateRatingData(_ data: PopupRatingDistribution) {
        popupRating = PopupRatingViewData(from: data)
    }

    func updateReviewData(_ data: PopupReviewList) {
        popupReviews += data.reviews.map { PopupReviewViewData(from: $0) }
    }

    func updatePickStatus(_ isPick: Bool) {
        popupMainInformation?.isPick = isPick
    }
}

// MARK: - Output
extension PopupDetailDataSource {
    func numberOfReviews() -> Int {
        return popupReviews.count
    }

    func numberOfCarouseImage() -> Int {
        guard let popupMainInformation else { return 1 }
        return popupMainInformation.popupImagesUrl.count
    }

    func popupImageItem(at indexPath: IndexPath) -> String {
        guard let popupMainInformation else { return "" }
        return popupMainInformation.popupImagesUrl[indexPath.row]
    }

    func mainInformationItem() -> PopupMainInformationViewData {
        guard let popupMainInformation else { return PopupMainInformationViewData.placeholder }
        return popupMainInformation
    }

    func detailInformationItem() -> PopupDetailInformationViewData {
        guard let popupDetailInformation else { return PopupDetailInformationViewData.placeholder }
        return popupDetailInformation
    }

    /// 평점의 개수가 가장 높은 평점의 인덱스를 반환. 단, 평점의 개수가 동률일 경우 평점의 인덱스가 높은 평점을 반환.
    func ratingItem() -> (PopupRatingViewData, Int) {
        guard let popupRating else { return (PopupRatingViewData.placeholder, 0) }

        let maximumIndex = popupRating.ratingDistribution.sorted {
            if $0.value == $1.value {
                return $0.key.ratingIndex > $0.key.ratingIndex
            } else {
                return $0.value > $1.value
            }
        }.first?.key.ratingIndex ?? 4

        return (popupRating, maximumIndex)
    }

    func reviewItem(at index: Int) -> PopupReviewViewData {
        return popupReviews[index]
    }

    func getPopupId() -> Int {
        guard let popupMainInformation else { return 0 }
        return popupMainInformation.popupId
    }

    func showPlaceholderData() {
        popupMainInformation = PopupMainInformationViewData.placeholder
        popupMainInformation = PopupMainInformationViewData.placeholder
        popupDetailInformation = PopupDetailInformationViewData.placeholder
        popupRating = PopupRatingViewData.placeholder
        showPlaceholderReviewData()
    }

    func showPlaceholderReviewData() {
        popupReviews = [PopupReviewViewData.placeholder]
    }
}

// MARK: - Mocking
extension PopupDetailDataSource {
    func generateMockData() {
        let imageUrl1 = "https://velog.velcdn.com/images/gration77/post/e15e428d-2a5b-47fb-98a5-43f28d20ea58/image.jpeg"
        let imageUrl2 = "https://velog.velcdn.com/images/gration77/post/3a6ba214-83b1-4c08-99f6-e973d1a3bb5e/image.png"
        let imageUrl3 = "https://velog.velcdn.com/images/gration77/post/4ad770f3-e573-48e8-a2ee-2ca3c302f122/image.png"

        let popupInformation = PopupInformation(
            popupId: -1,
            popupImagesUrl: [imageUrl1, imageUrl2, imageUrl3],
            popupTitle: "팝콘 팝업스토어",
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 50, to: Date())!,
            isPick: true,
            hashTags: ["#전시", "#팝업스토어", "#문화생활"],
            address: "서울특별시 강남구 강남대로 123",
            organizationUrl: "https://www.naver.com",
            businesesHours: "10:00 AM - 8:00 PM",
            introduce: "팝콘 전시회는 다양한 팝아트 작품과 굿즈를 만나볼 수 있는 공간입니다.",
            reservationUrl: "https://www.naver.com"
        )

        let review1 = PopupReview(
            profileImageUrl: "https://randomuser.me/api/portraits/men/1.jpg",
            nickName: "user123",
            reviewRating: 4.5,
            reviewDate: Date(),
            reviewImagesUrl: [imageUrl1, imageUrl2],
            reviewText: "매우 만족스러운 전시였습니다. 다양한 작품을 감상할 수 있었어요!",
            likeCount: 5,
            isLiked: true
        )

        let review2 = PopupReview(
            profileImageUrl: "https://randomuser.me/api/portraits/women/2.jpg",
            nickName: "artlover99",
            reviewRating: 5.0,
            reviewDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
            reviewImagesUrl: [imageUrl3],
            reviewText: "굿즈도 많고, 전시 공간도 아름다웠어요. 추천합니다!",
            likeCount: 0,
            isLiked: false
        )

        popupMainInformation = PopupMainInformationViewData(from: popupInformation)
        popupDetailInformation = PopupDetailInformationViewData(from: popupInformation)

        popupRating = PopupRatingViewData(from: PopupRatingDistribution(
            averageRating: 4.75,
            ratingDistribution: [.oneStar: 4, .twoStars: 0, .threeStars: 0, .fourStars: 0, .fiveStars: 0]
        ))

        popupReviews = [PopupReviewViewData(from: review1), PopupReviewViewData(from: review2)]
    }
}

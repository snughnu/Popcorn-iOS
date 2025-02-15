//
//  PopupDetailDataSource.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/13/25.
//

import Foundation

final class PopupDetailDataSource {
    private var carouselPopupImageUrls: [String] = []
    private var popupMainInformation: PopupMainInformationViewData?
    private var popupDetailInformation: PopupDetailInformationViewData?
    private var popupRating: PopupRatingViewData?
    private var popupReviews: [PopupReviewViewData]?
}

// MARK: - Input
extension PopupDetailDataSource {
    func updateData(_ data: PopupInformation) {
        carouselPopupImageUrls = data.popupImagesUrl
        popupMainInformation = PopupMainInformationViewData(from: data.mainInformation)
        popupDetailInformation = PopupDetailInformationViewData(from: data.detailInformation)
        popupRating = PopupRatingViewData(from: data.totalReview)
        popupReviews = data.totalReview.review.map { PopupReviewViewData(from: $0) }
    }
}

// MARK: - Output
extension PopupDetailDataSource {
    /// 컬렉션 뷰의 셀의 개수를 알기 위해 데이터의 개수를 반환하는 메서드입니다.
    /// - indexPath: 팝업 상세정보 화면에서 셀의 개수가 여러개인 경우는 섹션 2(리뷰) 뿐입니다.
    ///  이외는 셀의 개수가 1개이므로 `default`에서 1을 반환합니다.
    func numberOfReviews() -> Int {
        guard let popupReviews else { return 0 }
        return popupReviews.count
    }

    func numberOfCarouseImage() -> Int {
        return carouselPopupImageUrls.count
    }

    func popupImageItem(at indexPath: IndexPath) -> String {
        return carouselPopupImageUrls[indexPath.row]
    }

    func mainInformationItem() -> PopupMainInformationViewData {
        guard let popupMainInformation else { return PopupMainInformationViewData.placeholder }
        return popupMainInformation
    }

    func detailInformationItem() -> PopupDetailInformationViewData {
        guard let popupDetailInformation else { return PopupDetailInformationViewData.placeholder }
        return popupDetailInformation
    }

    /// starBreakDown의 value 중 최댓값 반환. 단, value가 같을 경우 key가 가장 큰 원소의 key를 반환
    func ratingItem() -> (PopupRatingViewData, Int) {
        guard let popupRating else { return (PopupRatingViewData.placeholder, 0) }
        let maximumIndex = popupRating.starBreakDown.sorted {
            $0.value == $1.value ? $0.key > $1.key : $0.value > $1.value
        }.first?.key ?? 4

        return (popupRating, maximumIndex)
    }

    func reviewItem(at index: Int) -> PopupReviewViewData {
        guard let popupReviews else { return PopupReviewViewData.placeholder}
        return popupReviews[index]
    }
}

// MARK: - Mocking
extension PopupDetailDataSource {
    func generateMockData() {
        let imageUrl1 = "https://velog.velcdn.com/images/gration77/post/e15e428d-2a5b-47fb-98a5-43f28d20ea58/image.jpeg"
        let imageUrl2 = "https://velog.velcdn.com/images/gration77/post/3a6ba214-83b1-4c08-99f6-e973d1a3bb5e/image.png"
        let imageUrl3 = "https://velog.velcdn.com/images/gration77/post/4ad770f3-e573-48e8-a2ee-2ca3c302f122/image.png"

        let review1 = PopupReview(
            profileImageUrl: "https://randomuser.me/api/portraits/men/1.jpg",
            nickName: "user123",
            reviewRating: 4.5,
            reviewDate: Date(),
            reviewImagesUrl: [imageUrl1, imageUrl2],
            reviewText: "매우 만족스러운 전시였습니다. 다양한 작품을 감상할 수 있었어요!"
        )

        let review2 = PopupReview(
            profileImageUrl: "https://randomuser.me/api/portraits/women/2.jpg",
            nickName: "artlover99",
            reviewRating: 5.0,
            reviewDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
            reviewImagesUrl: [imageUrl3],
            reviewText: "굿즈도 많고, 전시 공간도 아름다웠어요. 추천합니다!"
        )

        carouselPopupImageUrls = [imageUrl1, imageUrl2, imageUrl3]

        popupMainInformation = PopupMainInformationViewData(from: PopupMainInformation(
            popupTitle: "팝콘 팝업스토어",
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 10, to: Date())!,
            isUserPick: true,
            hashTags: ["#전시", "#팝업스토어", "#문화생활"]
        ))

        popupDetailInformation = PopupDetailInformationViewData(from: PopupDetailInformation(
            address: "서울특별시 강남구 강남대로 123",
            officialLink: "https://example.com",
            businesesHours: "10:00 AM - 8:00 PM",
            introduce: "팝콘 전시회는 다양한 팝아트 작품과 굿즈를 만나볼 수 있는 공간입니다."
        ))

        popupRating = PopupRatingViewData(from: PopupTotalReview(
            averageRating: 4.75,
            starBreakDown: [4: 2, 3: 0, 2: 0, 1: 0, 0: 0],
            review: [review1, review2]
        ))

        popupReviews = [PopupReviewViewData(from: review1), PopupReviewViewData(from: review2)]
    }
}

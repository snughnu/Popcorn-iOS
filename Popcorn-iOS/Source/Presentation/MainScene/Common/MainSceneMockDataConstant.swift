//
//  MockDataConstant.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 3/17/25.
//

import Foundation

struct MainSceneMockDataConstant {
    // MARK: - Image URL
    let imageUrls = [
        "https://gist.github.com/user-attachments/assets/12289a42-36d3-4f65-901e-632e7529acfa",      // 아닐라
        "https://gist.github.com/user-attachments/assets/a45d0e3f-b1a0-4675-b0b0-82cb7f9e4721",      // 취
        "https://gist.github.com/user-attachments/assets/660ccd91-fd4a-4d1b-a98d-9c3b6d5bc34f",      // 아키리
        "https://gist.github.com/user-attachments/assets/ffc183ff-4d2e-4f45-b6e6-b602b15b53cc",      // 핑구
        "https://gist.github.com/user-attachments/assets/c5b3f41b-eb6b-41aa-8eec-1bc4c1dff59a",      // 드래곤볼
        "https://gist.github.com/user-attachments/assets/e6fe6c4e-937f-4156-a6a1-a4232ab4feab"      // 풋볼
    ]

    // MARK: - Popup Titles
    let popupTitles = [
        "아닐라 팝업스토어",
        "취 팝업스토어 in 성수",
        "아키리 팝업스토어 in 부산",
        "핑구 팝업스토어",
        "드래곤볼 팝업스토어 in 잠실",
        "풋볼스탠다드 팝업스토어"
    ]

    // MARK: - Dates
    let startDateBefore5 = Calendar.current.date(byAdding: .day, value: -5, to: Date())!
    let startDateAfter10 = Calendar.current.date(byAdding: .day, value: 10, to: Date())!
    let startDateBefore60 = Calendar.current.date(byAdding: .day, value: -60, to: Date())!
    
    let endDateAfter10 = Calendar.current.date(byAdding: .day, value: 10, to: Date())!
    let endDateAfter20 = Calendar.current.date(byAdding: .day, value: 20, to: Date())!
    let endDateBefore35 = Calendar.current.date(byAdding: .day, value: -35, to: Date())!

    // MARK: - Addresses
    let addresses = [
        "서울특별시 강남구 팝콘로 1234",
        "서울특별시 성동구 성수동 팝콘로 33",
        "부산광역시 해운대구 팝콘팝업스토어팝콘로 1",
        "부산광역시 부산진구 팝콘로 86",
        "서울특별시 송파구 잠실 팝콘로 121",
        "서울특별시 마포구 홍대 팝콘로 4"
    ]

    static func generatePopupPreview() -> [PopupPreview] {
        let mockData = MainSceneMockDataConstant()
        return zip(mockData.popupTitles, zip(mockData.imageUrls, mockData.addresses)).enumerated().map { index, data in
            PopupPreview(
                popupId: index + 1,
                popupImageUrl: data.1.0,
                popupTitle: data.0,
                popupEndDate: mockData.endDateAfter10,
                popupStartDate: mockData.startDateBefore5,
                popupLocation: data.1.1
            )
        }
    }

    static func generateDetailData() -> (PopupInformation, PopupRatingDistribution, [PopupReview]) {
           let mockData = MainSceneMockDataConstant()

           let popupInfo = PopupInformation(
               popupId: 1,
               popupImagesUrl: [
                mockData.imageUrls[3],
                mockData.imageUrls[1],
                mockData.imageUrls[0],
                mockData.imageUrls[3]
               ],
               popupTitle: "팝콘 팝업스토어",
               startDate: Date(),
               endDate: Calendar.current.date(byAdding: .day, value: 50, to: Date())!,
               isPick: true,
               hashTags: ["#캐릭터", "#영화", "#음식"],
               address: "서울특별시 강남구 강남대로 1234567",
               organizationUrl: "https://www.naver.com",
               businesesHours: "10:00 AM - 8:00 PM",
               introduce: "귀여운 팝콘 마을부터 팝콘 친구들, 그리고 귀여운 굿즈들까지! 팝콘 마을 놀이터 물론 팝콘이들이 전달해주는 영화추천까지 다양한 체험존도 경험해보세요! 팝콘은 오는 4월 1일 서울을 시작으로 전국적으로 찾아갈 예정이니 많관부❤",
               reservationUrl: "https://www.naver.com"
           )

           let ratingDistribution = PopupRatingDistribution(
               averageRating: 4.5,
               ratingDistribution: [.fiveStars: 50, .fourStars: 30, .threeStars: 10, .twoStars: 5, .oneStar: 5]
           )

           let reviews = (1...4).map { index in
               PopupReview(
                   profileImageUrl: nil,
                   nickName: "사용자\(index)",
                   reviewRating: Float(arc4random_uniform(2) + 4),
                   reviewDate: mockData.startDateBefore5,
                   reviewImagesUrl: nil,
                   reviewText: "정말 재미있는 팝업스토어였어요!",
                   likeCount: Int(arc4random_uniform(100)),
                   isLiked: index % 2 == 0
               )
           }

           return (popupInfo, ratingDistribution, reviews)
       }

       static func generatePopupOverviewData() -> [PopupOverview] {
           let mockData = MainSceneMockDataConstant()
           let imageUrls = mockData.imageUrls

           return zip(mockData.popupTitles, zip(imageUrls, mockData.addresses)).enumerated().map { index, data in
               PopupOverview(
                   popupId: index + 1,
                   popupImageUrl: data.1.0,
                   popupTitle: data.0,
                   startDate: mockData.startDateBefore5,
                   endDate: mockData.endDateAfter10,
                   address: data.1.1
               )
           }
       }
   }

//
//  UserInterestPopup.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/17/24.
//

enum InterestCategory: String {
    case fashion = "패션"
    case beauty = "뷰티"
    case food = "음식"
    case character = "캐릭터"
    case dramaMovie = "영화 / 드라마"
    case lifeStyle = "라이프스타일"
    case art = "아트"
    case IT = "IT"
    case celebrity = "셀럽"
    case pet = "반려동물"
}

struct UserInterestPopup {
    let interestCategory: InterestCategory
    let popups: [PopupPreview]
}

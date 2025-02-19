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

    init?(serverValue: String) {
        switch serverValue {
        case "FASHION": self = .fashion
        case "BEAUTY": self = .beauty
        case "FOOD": self = .food
        case "CHARACTERS": self = .character
        case "MOVIES": self = .dramaMovie
        case "LIFESTYLE": self = .lifeStyle
        case "ART": self = .art
        case "IT": self = .IT
        case "CELEBRITY": self = .celebrity
        case "PETS": self = .pet
        default: return nil
        }
    }
}

struct UserInterestPopup {
    let interestCategory: InterestCategory
    let popups: [PopupPreview]
}

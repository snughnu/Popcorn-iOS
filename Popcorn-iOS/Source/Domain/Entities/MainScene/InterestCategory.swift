//
//  InterestCategory.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 2/19/25.
//

import Foundation

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

// MARK: - InterestCategory 서버 매핑
extension InterestCategory {
    var serverValue: String {
        switch self {
        case .fashion: return "FASHION"
        case .beauty: return "BEAUTY"
        case .food: return "FOOD"
        case .character: return "CHARACTER"
        case .dramaMovie: return "MOVIES"
        case .lifeStyle: return "LIFESTYLE"
        case .art: return "ART"
        case .IT: return "IT"
        case .celebrity: return "CELEBRITY"
        case .pet: return "PETS"
        }
    }
}

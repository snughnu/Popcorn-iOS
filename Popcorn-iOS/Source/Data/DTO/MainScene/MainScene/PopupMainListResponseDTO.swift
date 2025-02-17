//
//  PopupMainListResponseDTO.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/5/25.
//

import Foundation

struct PopupMainListResponseDTO: Decodable {
    let userPickPopups: [PopupPreviewResponseDTO]
    let userInterestPopups: [String: [PopupPreviewResponseDTO]]
    let closingSoonPopups: [PopupPreviewResponseDTO]

    enum CodingKeys: String, CodingKey {
        case userPickPopups = "topLikedPopups"
        case userInterestPopups = "categoryPopups"
        case closingSoonPopups = "allPopups"
    }
}

enum DtoInterestCategory: String {
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

    var convert: InterestCategory {
        switch self {
        case .fashion:
            return .fashion
        case .beauty:
            return .beauty
        case .food:
            return .food
        case .character:
            return .character
        case .dramaMovie:
            return .dramaMovie
        case .lifeStyle:
            return .lifeStyle
        case .art:
            return .art
        case .IT:
            return .IT
        case .celebrity:
            return .celebrity
        case .pet:
            return .pet
        }
    }
}

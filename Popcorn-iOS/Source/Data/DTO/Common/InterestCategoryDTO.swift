//
//  InterestCategoryDTO.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 3/12/25.
//

struct InterestCategoryDTO: Codable, Hashable {
    let category: String

    init(from entity: InterestCategory) {
        switch entity {
        case .fashion:
            category = "FASHION"
        case .beauty:
            category = "BEAUTY"
        case .food:
            category = "FOOD"
        case .character:
            category = "CHARACTERS"
        case .dramaMovie:
            category = "MOVIES"
        case .lifeStyle:
            category = "LIFESTYLE"
        case .art:
            category = "ART"
        case .IT:
            category = "IT"
        case .sports:
            category = "SPORTS"
        case .celebrity:
            category = "CELEBRITY"
        case .pet:
            category = "PETS"
        }
    }
}

extension InterestCategoryDTO {
    func toEntity() -> InterestCategory? {
        return switch category {
        case "FASHION": InterestCategory.fashion
        case "BEAUTY": InterestCategory.beauty
        case "FOOD": InterestCategory.food
        case "CHARACTERS": InterestCategory.character
        case "MOVIES": InterestCategory.dramaMovie
        case "LIFESTYLE": InterestCategory.lifeStyle
        case "ART": InterestCategory.art
        case "IT": InterestCategory.IT
        case "SPORTS": InterestCategory.sports
        case "CELEBRITY": InterestCategory.celebrity
        case "PETS": InterestCategory.pet
        default: nil
        }
    }
}

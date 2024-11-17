//
//  UserInterestPopup.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/17/24.
//

enum InterestCategory {
    case fashion
    case beauty
    case food
    case character
    case dramaMovie
    case lifeStyle
    case art
    case IT
    case celebrity
    case pet
}

struct UserInterestPopup {
    let interestCategory: InterestCategory
    let popups: [PopupPreview]
}

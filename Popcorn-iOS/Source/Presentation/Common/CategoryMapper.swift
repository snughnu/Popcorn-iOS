//
//  CategoryMapper.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 3/17/25.
//

struct CategoryMapper {
    /// PopupSectionCategory → 프레젠테이션용 문자열 변환
    /// - Parameter: 메인화면의 팝업 섹션 카테고리
    static func mapToTitle(_ category: PopupSectionCategory) -> String {
        switch category {
        case .todayRecommend: return ""
        case .userPick: return "찜 목록"
        case .userInterest(let interest): return mapToUserInterestedTitle(interest)
        case .closingSoon: return "지금 놓치면 안 될 팝업스토어"
        }
    }

    /// InterestCategory → 프레젠테이션용 문자열 변환
    /// - Parameter: 관심사 카테고리
    static func mapToUserInterestedTitle(_ interest: InterestCategory?) -> String {
        switch interest {
        case .fashion: return "패션"
        case .beauty: return "뷰티"
        case .food: return "음식"
        case .character: return "캐릭터"
        case .dramaMovie: return "드라마/영화"
        case .lifeStyle: return "라이프 스타일"
        case .art: return "예술"
        case .IT: return "IT"
        case .sports: return "스포츠"
        case .celebrity: return "셀럽"
        case .pet: return "반려동물"
        default: return ""
        }
    }

    /// 프레젠테이션용 문자열 → PopupSectionCategory 변환
    static func mapStringToPopupSectionCategory(_ title: String) -> PopupSectionCategory? {
        switch title {
        case "찜 목록": return .userPick
        case "지금 놓치면 안 될 팝업스토어": return .closingSoon
        default: return .userInterest(mapStringToInterestCategory(title))
        }
    }

    /// 프레젠테이션용 문자열 → InterestCategory 변환
    static func mapStringToInterestCategory(_ title: String) -> InterestCategory? {
        switch title {
        case "패션": return .fashion
        case "뷰티": return .beauty
        case "음식": return .food
        case "캐릭터": return .character
        case "드라마/영화": return .dramaMovie
        case "라이프 스타일": return .lifeStyle
        case "예술": return .art
        case "IT": return .IT
        case "스포츠": return .sports
        case "셀럽": return .celebrity
        case "반려동물": return .pet
        default: return nil
        }
    }
}

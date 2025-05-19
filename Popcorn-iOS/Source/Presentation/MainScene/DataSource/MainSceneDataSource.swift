//
//  MainSceneDataSource.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/12/25.
//

import Foundation

final class MainSceneDataSource {
    private var todayRecommend: [PopupPreview] = []
    private var userPick: [PopupPreview] = []
    private var userInterest: [(title: String, popups: [PopupPreview])] = []
    private var closingSoon: [PopupPreview] = []
}

// MARK: - Input
extension MainSceneDataSource {
    func updateData(_ list: PopupMainList) {
        self.todayRecommend = list.todayRecommend
        self.userPick = list.userPick
        self.closingSoon = list.closingSoon
        self.userInterest = list.userInterest
            .map { (CategoryMapper.mapToUserInterestedTitle($0.interestCategory), $0.popups) }
            .sorted { $0.title < $1.title }
    }

    func updateClosingSoonPopup(_ popups: [PopupPreview]) {
        self.closingSoon = popups
    }
}

// MARK: - Output
extension MainSceneDataSource {
    func numberOfPopups(in section: MainSceneSection) -> Int {
        switch section {
        case .userPick:
            return userPick.count
        case .userInterest(let index):
            guard index < userInterest.count else { return 0 }
            return userInterest[index].popups.count
        case .closingSoon:
            return closingSoon.count
        }
    }

    func numberOfTodayRecommend() -> Int {
        return todayRecommend.count
    }

    func numbersOfInterest() -> Int {
        return userInterest.count
    }

    func popup(for section: MainSceneSection, item: Int) -> PopupPreview? {
        switch section {
        case .userPick:
            guard item < userPick.count else { return nil }
            return userPick[item]
        case .userInterest(let index):
            guard index < userPick.count, item < userInterest[index].popups.count else { return nil }
            return userInterest[index].popups[item]
        case .closingSoon:
            guard item < closingSoon.count else { return nil }
            return closingSoon[item]
        }
    }

    /// MainCarouselView가 데이터를 채우기 위해 사용하는 메서드
    func getTodayRecommend(item: Int) -> PopupPreview? {
        guard item < todayRecommend.count else { return nil }
        return todayRecommend[item]
    }

    func interestCategoryTitle(for section: MainSceneSection) -> String? {
        guard case .userInterest(let index) = section, index < userInterest.count else {
            return nil
        }

        return userInterest[index].title
    }
}

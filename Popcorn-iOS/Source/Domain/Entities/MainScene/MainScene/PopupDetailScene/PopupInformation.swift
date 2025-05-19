//
//  PopupInformation.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 12/30/24.
//

import Foundation

struct PopupInformation {
    let id: Int
    let imageUrls: [String]
    let title: String
    let startDate: Date
    let endDate: Date
    let isPick: Bool
    var hashTags: [String]
    let address: String
    let organizationUrl: String
    let businesesHours: String
    let introduce: String
    let reservationUrl: String

    var isFinished: Bool {
        return Date() >= endDate
    }

    var isWriteReviewEnabled: Bool {
        let reviewDeadline = Calendar.current.date(byAdding: .day, value: 30, to: endDate) ?? endDate
        return Date() <= reviewDeadline
    }
}

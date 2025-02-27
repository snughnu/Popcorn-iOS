//
//  PopupInformationResponseDTO.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/17/25.
//

import Foundation

struct PopupInformationResponseDTO: Decodable {
    let popupId: Int
    let popupImagesUrl: [String]
    let popupTitle: String
    let startDate: String
    let endDate: String
    let isPick: Bool

    let address: String
    let officialLink: String
    let businesesHours: String
    let introduce: String
    let reservationUrl: String

    enum CodingKeys: String, CodingKey {
        case popupId
        case popupImagesUrl = "popupImage"
        case popupTitle = "title"
        case startDate = "startedAt"
        case endDate = "endedAt"
        case isPick = "isLiked"

        case address = "location"
        case officialLink = "organizerUrl"
        case businesesHours = "hours"
        case introduce = "contents"
        case reservationUrl
    }
}

extension PopupInformationResponseDTO {
    func toEntity() -> PopupInformation {
        let errorDate = DateFormatter.apiDateFormatter.date(from: "1900-01-01 00:00:00")!
        let startDate = DateFormatter.apiDateFormatter.date(from: startDate) ?? errorDate
        let endDate = DateFormatter.apiDateFormatter.date(from: endDate) ?? errorDate

        return PopupInformation(
            popupId: popupId,
            popupImagesUrl: popupImagesUrl,
            popupTitle: popupTitle,
            startDate: startDate,
            endDate: endDate,
            isPick: isPick,
            hashTags: [],
            address: address,
            organizationUrl: officialLink,
            businesesHours: businesesHours,
            introduce: introduce,
            reservationUrl: reservationUrl
        )
    }
}

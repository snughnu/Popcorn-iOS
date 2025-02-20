//
//  PopupInformationResponseDTO.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/17/25.
//

import Foundation

struct PopupInformationResponseDTO: Decodable {
    let popupId: Int
    let popupImages: [String]
    let popupTitle: String
    let startDate: String
    let endDate: String
    let isUserPick: Bool

    let address: String
    let officialLink: String
    let businesesHours: String
    let introduce: String
    let reservationUrl: String

    enum CodingKeys: String, CodingKey {
        case popupId
        case popupImages = "popupImage"
        case popupTitle = "title"
        case startDate = "startedAt"
        case endDate = "endedAt"
        case isUserPick = "isLiked"

        case address = "location"
        case officialLink = "organizerUrl"
        case businesesHours = "hours"
        case introduce = "contents"
        case reservationUrl
    }
}

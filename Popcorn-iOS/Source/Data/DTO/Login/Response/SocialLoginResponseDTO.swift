//
//  SocialLoginResponseDTO.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 2/10/25.
//

import Foundation

struct SocialLoginResponseDTO: Decodable {
    let access: String?
    let refresh: String?
    let accessExpiredAt: String?
    let refreshExpiredAt: String?
    let newUser: Bool

    enum CodingKeys: String, CodingKey {
        case access
        case refresh
        case accessExpiredAt
        case refreshExpiredAt
        case newUser
    }

    func toToken() -> Token? {
        guard let access = access,
              let refresh = refresh,
              let accessExpiredAt = accessExpiredAt,
              let refreshExpiredAt = refreshExpiredAt else {
            return nil
        }

        return Token(
            accessToken: access,
            refreshToken: refresh,
            accessExpiredAt: accessExpiredAt,
            refreshExpiredAt: refreshExpiredAt
        )
    }
}

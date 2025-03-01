//
//  KakaoSignUpResponseDTO.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 2/23/25.
//

import Foundation

struct SocialSignUpResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let accessExpiredAt: String
    let refreshExpiredAt: String
    let newUser: Bool

    enum CodingKeys: String, CodingKey {
        case accessToken = "access"
        case refreshToken = "refresh"
        case accessExpiredAt
        case refreshExpiredAt
        case newUser
    }

    func toToken() -> Token {
        return Token(
            accessToken: accessToken,
            refreshToken: refreshToken,
            accessExpiredAt: accessExpiredAt,
            refreshExpiredAt: refreshExpiredAt
        )
    }
}

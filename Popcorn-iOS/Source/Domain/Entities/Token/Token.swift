//
//  Token.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/15/25.
//

import Foundation

struct Token: Decodable {
    let accessToken: String
    let refreshToken: String
    let accessExpiredAt: String
    let refreshExpiredAt: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case accessExpiredAt = "access_expired_at"
        case refreshExpiredAt = "refresh_expired_at"
    }
}

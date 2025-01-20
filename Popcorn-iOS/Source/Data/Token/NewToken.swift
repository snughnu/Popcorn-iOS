//
//  NewToken.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/21/25.
//

import Foundation

struct NewToken: Decodable {
    let accessToken: String
    let refreshToken: String
    let accessExpiredAt: String
    let refreshExpiredAt: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "new_access_token"
        case refreshToken = "new_refresh_token"
        case accessExpiredAt = "new_access_expired_at"
        case refreshExpiredAt = "new_refresh_expired_at"
    }
}

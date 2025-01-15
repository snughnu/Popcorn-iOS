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
}

//
//  SocialLoginResponseDTO.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 2/10/25.
//

import Foundation

struct SocialLoginResponseDTO: Decodable {
    let newUser: Bool
    let token: Token?

    enum CodingKeys: String, CodingKey {
        case newUser
        case token
    }
}

//
//  SocialLoginRequestDTO.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 2/11/25.
//

import Foundation

struct SocialLoginRequestDTO: Encodable {
    let idToken: String
    let provider: String

    enum CodingKeys: String, CodingKey {
        case idToken
        case provider
    }
}

//
//  KakaoSignUpRequestDTO.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 2/23/25.
//

import Foundation

struct SocialSignUpRequestDTO: Codable {
    let idToken: String
    let secondSignupDTO: SecondSignupDTO

    enum CodingKeys: String, CodingKey {
        case idToken
        case secondSignupDTO = "secondSignupDto"
    }
}

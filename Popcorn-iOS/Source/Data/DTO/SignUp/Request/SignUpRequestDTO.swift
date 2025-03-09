//
//  SignUpRequestDTO.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/19/25.
//

import Foundation

struct FirstSignupDTO: Codable {
    let name: String
    let username: String
    let password: String
    let email: String
}

struct SecondSignupDTO: Codable {
    let nickname: String
    let profileId: Int
    let interests: [String]
}

struct SignUpRequestDTO: Codable {
    let firstSignupDTO: FirstSignupDTO
    var secondSignupDTO: SecondSignupDTO?

    enum CodingKeys: String, CodingKey {
        case firstSignupDTO = "firstSignupDto"
        case secondSignupDTO = "secondSignupDto"
    }
}

//
//  SignUpRequestDTO.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/19/25.
//

import Foundation

struct FirstSignupDto: Encodable {
    let name: String
    let username: String
    let password: String
    let email: String
}

struct SecondSignupDto: Encodable {
    let nickname: String
    let profileId: Int
    let interests: [String]
}

struct SignUpRequestDTO: Encodable {
    let firstSignupDto: FirstSignupDto
    var secondSignupDto: SecondSignupDto?
}

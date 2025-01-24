//
//  SignUpData.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/19/25.
//

import Foundation

struct SignUpData: Codable {
    struct FirstSignupDto: Codable {
        let name: String
        let username: String
        let password: String
        let email: String
    }

    struct SecondSignupDto: Codable {
        let nickname: String
        let profileId: Int
        let interests: [String]
    }

    let firstSignupDto: FirstSignupDto
    var secondSignupDto: SecondSignupDto?
}

//
//  SignUpData.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/19/25.
//

import Foundation

struct SignUpData: Codable {
    struct FirstSignUpDto: Codable {
        let username: String
        let password: String
        let name: String
        let email: String
    }

    struct SecondSignUpDto: Codable {
        let nickname: String
        let profileId: Int
        let interests: [String]
    }

    let firstSignUpDto: FirstSignUpDto
    var secondSignUpDto: SecondSignUpDto?
}

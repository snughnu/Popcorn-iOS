//
//  LoginRequestDTO.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/26/25.
//

import Foundation

struct LoginRequestDTO: Encodable {
    let username: String
    let password: String
}

//
//  LoginResponse.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/12/25.
//

import Foundation

struct LoginResponse: Decodable {
    let resultCode: Int
    let status: String
    let data: Token
}

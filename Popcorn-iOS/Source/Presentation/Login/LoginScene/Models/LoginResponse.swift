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
    let data: LoginResponseData
}

enum LoginResponseData: Decodable {
    case token(Token)
    case errorMessage(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let token = try? container.decode(Token.self) {
            self = .token(token)
        } else if let errorMessage = try? container.decode(String.self) {
            self = .errorMessage(errorMessage)
        } else {
            throw DecodingError.typeMismatch(
                LoginResponseData.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Expected Token or String in data field"
                )
            )
        }
    }
}

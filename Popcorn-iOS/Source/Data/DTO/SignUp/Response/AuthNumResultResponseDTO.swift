//
//  AuthNumResultResponseDTO.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 2/9/25.
//

import Foundation

struct AuthNumResultResponseDTO: Decodable {
    let resultCode: Int
    let status: String
    let data: String
}

//
//  ValidateVerificationCodeResponseDTO.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 2/4/25.
//

import Foundation

struct ValidateVerificationCodeResponseDTO: Decodable {
    let resultCode: Int
    let status: String
    let data: String
}

//
//  CheckUsernameResponseDTO.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 2/4/25.
//

import Foundation

struct CheckUsernameResponseDTO: Decodable {
    let resultCode: Int
    let status: String
    let data: String
}

//
//  ReissueResponseDTO.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/21/25.
//

import Foundation

struct ReissueResponseDTO: Decodable {
    let resultCode: Int
    let status: String
    let data: NewToken
}

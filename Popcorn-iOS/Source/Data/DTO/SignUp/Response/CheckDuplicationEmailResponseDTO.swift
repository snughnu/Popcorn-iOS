//
//  CheckDuplicationEmailResponseDTO.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 2/11/25.
//

import Foundation

struct CheckDuplicationEmailResponseDTO: Decodable {
    let resultCode: Int
    let status: String
    let data: String
}

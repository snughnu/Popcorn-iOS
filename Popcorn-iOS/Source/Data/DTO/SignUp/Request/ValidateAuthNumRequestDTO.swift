//
//  ValidateAuthNumRequestDTO.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 2/4/25.
//

import Foundation

struct ValidateAuthNumRequestDTO: Encodable {
    let email: String
    let authNum: String
}

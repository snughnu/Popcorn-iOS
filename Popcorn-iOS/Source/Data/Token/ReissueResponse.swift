//
//  ReissueResponse.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/21/25.
//

import Foundation

struct ReissueResponse: Decodable {
    let resultCode: Int
    let status: String
    let data: Token
}

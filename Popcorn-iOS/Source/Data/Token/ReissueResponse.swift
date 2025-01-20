//
//  ReissueResponse.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/21/25.
//

import Foundation

struct ReissueResponse<T: Decodable>: Decodable {
    let resultCode: Int
    let status: String
    let data: T
}

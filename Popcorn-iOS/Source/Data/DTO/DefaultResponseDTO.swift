//
//  DefaultResponseDTO.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/26/25.
//

struct DefaultResponseDTO: Decodable {
    let resultCode: Int
    let status: String
    let data: String
}

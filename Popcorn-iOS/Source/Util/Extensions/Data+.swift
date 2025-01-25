//
//  Data+.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 1/25/25.
//

import Foundation

extension Data {
    mutating func appendString(_ input: String) {
        if let input = input.data(using: .utf8) {
            self.append(input)
        }
    }
}

//
//  Date+.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 11/19/24.
//

import Foundation

extension Date {
    func toYYMMDDString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd"
        return dateFormatter.string(from: self)
    }
}

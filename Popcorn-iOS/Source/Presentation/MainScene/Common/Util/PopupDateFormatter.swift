//
//  PopupDateFormatter.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/9/25.
//

import Foundation

struct PopupDateFormatter {
    static func convertToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd"
        return dateFormatter.string(from: date)
    }
}

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
    
    static func calculateDDay(from dueDate: Date) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let due = calendar.startOfDay(for: dueDate)
        let components = calendar.dateComponents([.day], from: today, to: due).day ?? 0
        return String(components)
    }
}

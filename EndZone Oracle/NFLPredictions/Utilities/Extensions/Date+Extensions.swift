//
//  Date+Extensions.swift
//  NFLPredictions
//
//  Date formatting utilities
//

import Foundation

extension Date {
    func formatted(as style: DateFormatStyle) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style.dateStyle
        formatter.timeStyle = style.timeStyle
        return formatter.string(from: self)
    }
    
    var shortDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
    
    var mediumDateTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    var relativeTime: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}

struct DateFormatStyle {
    let dateStyle: DateFormatter.Style
    let timeStyle: DateFormatter.Style
    
    static let short = DateFormatStyle(dateStyle: .short, timeStyle: .none)
    static let medium = DateFormatStyle(dateStyle: .medium, timeStyle: .short)
    static let long = DateFormatStyle(dateStyle: .long, timeStyle: .medium)
}


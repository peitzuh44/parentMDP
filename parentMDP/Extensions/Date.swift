//
//  DateExtensions.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/15.
//

import SwiftUI

extension Date {
    func formattedDate() -> String {
           let formatter = DateFormatter()
           formatter.dateFormat = "MM/dd/yyyy"
           return formatter.string(from: self)
       }

    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var date: Date
    }
}

extension Date {
    func startOfCurrentWeek() -> Date {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: self)
        let weekday = calendar.component(.weekday, from: today)
        let daysToSubtract = (weekday - calendar.firstWeekday) % 7
        let startOfWeek = calendar.date(byAdding: .day, value: -daysToSubtract, to: today)!
        return calendar.startOfDay(for: startOfWeek)
    }
    
    func endOfCurrentWeek() -> Date {
        let calendar = Calendar.current
        let startOfWeek = self.startOfCurrentWeek()
        let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
        return endOfWeek
    }
}

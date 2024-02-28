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
//
//    func format(_ format: String) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = format
//
//        return formatter.string(from: self)
//    }
//
//    var isToday: Bool {
//        return Calendar.current.isDateInToday(self)
//    }
//
//    // fetching week base on given date
//
//    func fetchWeek(_ date: Date = .init()) -> [WeekDay]{
//        let calendar = Calendar.current
//        let startOfDate = calendar.startOfDay(for: date)
//
//        var week: [WeekDay] = []
//        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)
//        guard let startOfWeek = weekForDate?.start else {
//            return []
//        }
//        (0..<7).forEach { index in
//            if let weekDay = calendar.date(byAdding: .day, value: index, to: startOfWeek) {
//                week.append(.init(date: weekDay))
//            }
//
//        }
//        return week
//    }
    
    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var date: Date
    }
}

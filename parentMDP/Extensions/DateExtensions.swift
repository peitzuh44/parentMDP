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

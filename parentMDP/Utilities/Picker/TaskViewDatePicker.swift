//
//  TaskViewDatePicker.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/13.
//

import SwiftUI

struct TaskViewDatePicker: View {
    @Binding var selectedDate: Date 
    
    private var displayDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, Y"
        
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        
        if dateFormatter.string(from: selectedDate) == dateFormatter.string(from: today) {
            return "Today"
        } else if dateFormatter.string(from: selectedDate) == dateFormatter.string(from: tomorrow) {
            return "Tomorrow"
        } else if dateFormatter.string(from: selectedDate) == dateFormatter.string(from: yesterday) {
            return "Yesterday"
        } else {
            return dateFormatter.string(from: selectedDate)
        }
    }
    
    var body: some View {
        HStack {
            Button(action: {
                self.changeDate(by: -1)
            }) {
                Image(systemName: "chevron.left")
            }
            
            Text(displayDate)
                .frame(minWidth: 0, maxWidth: .infinity)
            
            Button(action: {
                self.changeDate(by: 1)
            }) {
                Image(systemName: "chevron.right")
            }
        }
        .foregroundColor(.white)
    }
    
    private func changeDate(by days: Int) {
        if let newDate = Calendar.current.date(byAdding: .day, value: days, to: selectedDate) {
            selectedDate = newDate
        }
    }
}

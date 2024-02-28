//
//  WeekdayPicker.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI

import SwiftUI
struct Weekday: Identifiable {
   let id: Int
   let name: String
}

struct WeekdayPicker: View {
   let weekdays = [
       Weekday(id: 0, name: "M"),
       Weekday(id: 1, name: "T"),
       Weekday(id: 2, name: "W"),
       Weekday(id: 3, name: "Th"),
       Weekday(id: 4, name: "F"),
       Weekday(id: 5, name: "S"),
       Weekday(id: 6, name: "Su")
   ]
   @Binding var selectedDays: Set<Int>

   var body: some View {
               HStack {
                   ForEach(weekdays) { weekday in
                       Button(action: {
                           if selectedDays.contains(weekday.id) {
                               selectedDays.remove(weekday.id)
                           } else {
                               selectedDays.insert(weekday.id)
                           }
                       }) {
                           Text(weekday.name)
                               .foregroundColor(selectedDays.contains(weekday.id) ? .white : .white)
                               .frame(width: 42, height: 42)
                               .background(selectedDays.contains(weekday.id) ? Color.customPurple : Color.gray.opacity(0.2))
                               .cornerRadius(10)
                       }
                   }
               }
               .padding()
       }
   }



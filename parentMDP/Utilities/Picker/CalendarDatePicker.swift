//
//  CalendarDatePicker.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/15.
//

import SwiftUI

struct CalendarDatePicker: View {
    // MARK: Properties
    @Environment(\.presentationMode) var presentationMode
    @State private var localSelectedDate: Date = Date()
    var onDateSelected: ((Date) -> Void)?

    // MARK: Body
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            DatePicker("Birthdate", selection: $localSelectedDate, displayedComponents: .date)
                .labelsHidden()
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            
            // MARK: Fetching
            .onChange(of: localSelectedDate) { newDate in
                    onDateSelected?(newDate)
                    presentationMode.wrappedValue.dismiss()
                }
        }
    }
}

#Preview {
    CalendarDatePicker()
}

//
//  RoutinePicker.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI

// MARK: Options


enum RoutineOptions: String, CaseIterable {
    case morning = "Morning"
    case evening = "Evening"
    case anytime = "Anytime"
    static func fromString(_ routine: String) -> RoutineOptions? {
        return RoutineOptions(rawValue: routine.capitalized)
    }
}

struct RoutinePicker: View {
    // MARK: Properties

    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedRoutine: RoutineOptions?
    
    // MARK: Body
    var body: some View {
        ZStack {
            Color.customNavyBlue.ignoresSafeArea(.all)
            VStack (alignment: .leading){
                Text("SELECT ROUTINE")
                    .foregroundColor(.white)
                    .font(.callout)
                    .padding(.horizontal, 10)
                
                ForEach(RoutineOptions.allCases, id: \.self) { option in
                    Button(action: {
                        self.selectedRoutine = option
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack (){
                            Text(emoji(for: option))
                            Text(option.rawValue).foregroundColor(.white)
                            Spacer()
                            if selectedRoutine == option{
                                Image(systemName: "checkmark")
                                    .foregroundColor(.green)
                                              }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 24)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.customDarkBlue))
                    }
                }
            }
            .padding(.horizontal, 10)
        }
    }

    // MARK: Functions
    private func emoji(for routine: RoutineOptions) -> String {
        switch routine {
        case .morning:
            return "☀️"
        case .evening:
            return "🌙"
        case .anytime:
            return "❓"
        }
    }
}



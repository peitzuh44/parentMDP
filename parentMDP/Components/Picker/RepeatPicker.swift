//
//  RepeatPicker.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI


// MARK: Options
enum RepeatingOptions: String, CaseIterable{
    case oneOff = "Does not repeat"
    case daily = "Everyday"
    case weekly = "Every week"
    case weekday = "Every weekday"
    case weekend = "Every weekend"
    case custom = "Custom repeat"
    static func fromString(_ repeating: String) -> RepeatingOptions? {
        return RepeatingOptions(rawValue: repeating.capitalized)
    }
    
}


struct RepeatPicker: View {
    
    // MARK: Properties
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedRepeat: RepeatingOptions

    
    // MARK: Body
    var body: some View {
        ZStack {
            Color.customNavyBlue.ignoresSafeArea(.all)
            VStack(alignment: .leading) {
                
                // MARK: One-Off Option
                Text("NO REPEAT")
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                
                Button(action: {
                    self.selectedRepeat = .oneOff
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "repeat.1")
                            .foregroundColor(.white)
                        Text(RepeatingOptions.oneOff.rawValue).foregroundColor(.white)
                        Spacer()
                        if selectedRepeat == .oneOff{
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                                          }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 24)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.customDarkBlue))
                }
                .padding(.horizontal, 10)

                // MARK: Repeat Section
                Text("REPEAT")
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                
                ForEach(RepeatingOptions.allCases, id: \.self) { option in
                    if option != .oneOff {
                        Button(action: {
                            self.selectedRepeat = option
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Image(systemName: "repeat")
                                    .foregroundColor(.white)
                                Text(option.rawValue).foregroundColor(.white)
                                Spacer()
                                if selectedRepeat == option{
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.green)
                                                  }
                                
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 24)
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.customDarkBlue))
                        }
                        .padding(.horizontal, 10)
                    }
                }
            }
        }
    }
}

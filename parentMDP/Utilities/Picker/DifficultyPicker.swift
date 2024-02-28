//
//  DifficultyPicker.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI

enum DifficultyOptions: String, CaseIterable {
    case easy = "Easy"
    case mid = "Medium"
    case hard = "Hard"
    
    static func fromString(_ difficulty: String) -> DifficultyOptions? {
        return DifficultyOptions(rawValue: difficulty.capitalized)
    }
}

struct DifficultyPicker: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedDifficulty: DifficultyOptions
    
    var body: some View {
        ZStack {
            Color.customNavyBlue.ignoresSafeArea(.all)
            VStack(alignment: .leading) {
                Text("SELECT DIFFICULTY")
                    .foregroundColor(.white)
                    .font(.callout)
                    .padding(.horizontal, 10)
                
                ForEach(DifficultyOptions.allCases, id: \.self) { option in
                    Button(action: {
                        self.selectedDifficulty = option
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Text(emoji(for: option))
                            Text(option.rawValue).foregroundColor(.white)
                            Spacer()
                            if selectedDifficulty == option{
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
    
    private func emoji(for difficulty: DifficultyOptions) -> String {
        switch difficulty {
        case .easy:
            return "🟢"
        case .mid:
            return "🟡"
        case .hard:
            return "🔴"
        }
    }
    
    private func color(for difficulty: DifficultyOptions) -> Color {
        switch difficulty {
        case .easy:
            return Color.green
        case .mid:
            return Color.orange
        case .hard:
            return Color.red
        }
    }
}

func difficultyColor(for difficulty: String) -> Color {
       switch difficulty {
       case "Easy":
           return Color.green.opacity(0.6)
       case "Medium":
           return Color.yellow.opacity(0.6)
       case "Hard":
           return Color.red.opacity(0.6)
       default:
           return Color.gray.opacity(0.6)
       }
   }

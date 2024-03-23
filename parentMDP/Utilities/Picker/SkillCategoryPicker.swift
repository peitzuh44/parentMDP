//
//  SkillCategoryPicker.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/3/23.
//

import SwiftUI


struct SkillCategoryPicker: View {
    // MARK: Properties
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedCategory: SkillCategoryOption
    var body: some View {
        ZStack {
            Color.customNavyBlue.ignoresSafeArea(.all)
            VStack(alignment: .leading) {
                Text("SELECT SKILLS")
                    .foregroundColor(.white)
                    .font(.callout)
                    .padding(.horizontal, 10)
                
                ForEach(SkillCategoryOption.allCases, id: \.self) { option in
                    Button(action: {
                        self.selectedCategory = option
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Text(option.emoji())
                            Text(option.description).foregroundColor(.white)
                            Spacer()
                            if selectedCategory == option{
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
    
    private func emoji(for category: SkillCategoryOption) -> String {
        switch category {

        case .sports:
            return "💪🏻"
        case .mathLogic:
            return "🧮"
        case .language:
            return "📝"
        case .dance:
            return "💃🏻"
        case .music:
            return "🎹"
        case .stem:
            return "🧪"
        case .visualArt:
            return "🎨"
        }
    }
}

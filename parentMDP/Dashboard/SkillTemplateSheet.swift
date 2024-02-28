//
//  SkillTemplateSheet.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/27.
//

import SwiftUI

struct SkillTemplateSheet: View {
    var kidID: String
    @ObservedObject var skillVM = SkillViewModel()
    @State private var selectedSkillTemplate: SkillTemplateModel?
    @State private var selectedCategory: SkillCategoryOption = .sports
    @State private var searchTerm: String = ""


    var body: some View {
        ZStack {
            Color.customDarkBlue.ignoresSafeArea(.all)
            VStack {
                // search
                CustomTextfield(text: $searchTerm, placeholder: "search for skill", icon: "", background: Color.customNavyBlue, color: Color.white)
                
                SkillCategoryPicker(selectedCategory: $selectedCategory)
                VStack {
                    List{
                        ForEach(skillVM.skillTemplates) {
                            template in
                            HStack {
                                Text(template.name).foregroundColor(.white)
                                Spacer()
                                Image("add")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)
                            }
                            .padding(.vertical, 8)
                            .onTapGesture {
                                selectedSkillTemplate = template
                                skillVM.addSkillFromTemplate(selectedKidID: kidID, template: template)
                            }

                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.customNavyBlue)
                                .padding(.vertical, 2)
                        )

            
            
            
                    }
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                }
                }
            .onChange(of: selectedCategory) {
                skillVM.fetchSkillTemplates(category: selectedCategory.rawValue)
            }
                
                
                
                
                
                
            }
            
        }
}




enum SkillCategoryOption: String, CaseIterable {
    case sports = "sport"
    case language = "language"
    case music = "music"
    case dance = "dance"
    case stem = "stem"
    case mathLogic = "math & logic"
    case visualArt = "visual art"
    
    static func fromString(_ skill: String) -> SkillCategoryOption? {
        return SkillCategoryOption(rawValue: skill.capitalized)
    }
}

struct SkillCategoryPicker: View {
    @Binding var selectedCategory: SkillCategoryOption

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(SkillCategoryOption.allCases, id: \.self) {
                    category in
                    Button(action: {
                        selectedCategory = category
                    }) {
                        HStack(spacing: 10) {
                            Text(emoji(for: category))
                            Text(category.rawValue)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(selectedCategory == category ? Color.customPurple : Color.black.opacity(0.6))
                        .cornerRadius(10)
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


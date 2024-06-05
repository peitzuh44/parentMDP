//
//  SkillTemplateSheet.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/27.
//

import SwiftUI

struct SkillTemplateSheet: View {
    @Environment(\.presentationMode) var presentationMode

    // MARK: Properties
    var kidID: String
    @ObservedObject var kidVM = KidViewModel()
    @State private var selectedSkillTemplate: SkillTemplateModel?
    @State private var selectedCategory: SkillCategoryOption = .sports
    @State private var searchTerm: String = ""
    @Binding var showAddSkillSheet: Bool

    // MARK: Body
    var body: some View {
        ZStack {
            Color.customDarkBlue.ignoresSafeArea(.all)
                VStack {
                    // search
                    CustomTextfield(text: $searchTerm, placeholder: "search for skill", icon: "", background: Color.customNavyBlue, color: Color.white)
                    
                    // MARK: CHANGE TO "HScrollPicker"

                    HScrollPicker(selection: $selectedCategory) { category in
                        HStack(spacing: 10) {
                            Text(category.emoji()) // Use the closure to dynamically provide the content
                            Text(category.description)
                        }
                        .padding()
                        .background(selectedCategory == category ? Color.customPurple : Color.customNavyBlue)
                        .cornerRadius(20)
                    }
                    VStack {
                        List{
                            ForEach(kidVM.skillTemplates) {
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
                                    kidVM.addSkillFromTemplate(selectedKidID: kidID, template: template)
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
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showAddSkillSheet = true
                        }
                    } label: {
                        Text("add new")
                            .padding()
                            .foregroundStyle(.white)
                            .background(Color.customPurple)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }

                        
    
                }
                // MARK: Fetching
                .onChange(of: selectedCategory) {
                    kidVM.fetchSkillTemplates(category: selectedCategory.description)
                
                }
                
                
                
                
                
                
            }
            
        }
}





enum SkillCategoryOption: CaseIterable, Hashable, CustomStringConvertible {
    case sports, mathLogic, language, dance, music, stem, visualArt

    var description: String {
        switch self {
        case .sports: return "Sports"
        case .mathLogic: return "Math"
        case .language: return "Language"
        case .dance: return "Dance"
        case .music: return "Music"
        case .stem: return "STEM"
        case .visualArt: return "Visual Arts"
        }
    }

    func emoji() -> String {
        switch self {
        case .sports: return "💪🏻"
        case .mathLogic: return "🧮"
        case .language: return "📝"
        case .dance: return "💃🏻"
        case .music: return "🎹"
        case .stem: return "🧪"
        case .visualArt: return "🎨"
        }
    }
}

//struct SkillCategorySelector: View {
//    @Binding var selectedCategory: SkillCategoryOption
//
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 8) {
//                ForEach(SkillCategoryOption.allCases, id: \.self) {
//                    category in
//                    Button(action: {
//                        selectedCategory = category
//                    }) {
//                        HStack(spacing: 10) {
//                            Text(emoji(for: category))
//                            Text(category.rawValue)
//                                .foregroundColor(.white)
//                        }
//                        .padding()
//                        .background(selectedCategory == category ? Color.customPurple : Color.black.opacity(0.6))
//                        .cornerRadius(10)
//                    }
//                }
//            }
//            .padding(.horizontal, 10)
//        }
//    }
//    private func emoji(for category: SkillCategoryOption) -> String {
//        switch category {
//
//        case .sports:
//            return "💪🏻"
//        case .mathLogic:
//            return "🧮"
//        case .language:
//            return "📝"
//        case .dance:
//            return "💃🏻"
//        case .music:
//            return "🎹"
//        case .stem:
//            return "🧪"
//        case .visualArt:
//            return "🎨"
//        }
//    }
//
//}
//

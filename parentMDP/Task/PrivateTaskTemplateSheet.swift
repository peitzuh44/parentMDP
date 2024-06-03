//
//  TaskTemplateSheet.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/6/1.
//

import SwiftUI

struct PrivateTaskTemplateSheet: View {
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: Properties
    @ObservedObject var kidVM = KidViewModel()
    @State private var selectedTaskTemplate: TaskTemplateModel?
    @State private var selectedCategory: TaskCategorySelection = .mental
    @State private var searchTerm: String = ""
    @Binding var showAddPrivateTaskSheet: Bool
    
    
    var body: some View {
        ZStack {
            Color.customDarkBlue.ignoresSafeArea(.all)
                VStack {
                    // search
                    CustomTextfield(text: $searchTerm, placeholder: "search for task", icon: "", background: Color.customNavyBlue, color: Color.white)
                    
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
//                                    selectedTaskTemplate = template
//                                    kidVM.addSkillFromTemplate(selectedKidID: kidID, template: template)
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
                            showAddPrivateTaskSheet = true
                        }
                    } label: {
                        Text("Add custom task")
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




enum TaskCategorySelection: CaseIterable, Hashable, CustomStringConvertible {
    case physical, mental, social, learning

    var description: String {
        switch self {
        case .physical: return "fitness"
        case .mental: return "mind"
        case .social: return "social"
        case .learning: return "knowledge & skills"
        }
    }

    func emoji() -> String {
        switch self {
        case .physical: return "💪🏻"
        case .mental: return "🧘🏻‍♀️"
        case .social: return "🤝🏻"
        case .learning: return "🧠"

        }
    }
}

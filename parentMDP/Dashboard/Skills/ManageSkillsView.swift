//
//  ManageSkillsView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/27.
//

import SwiftUI

struct ManageSkillsView: View {
    
    // MARK: Properties
    var kidID: String
    
    @ObservedObject var skillVM = SkillViewModel()
    @State private var selectedSkill: SkillModel?
    @State private var showActionSheet = false
    @State private var showSkillTemplateSheet = false
    @State private var showAddNewSkillSheet = false
    
    
    // MARK: Body
    var body: some View {
        NavigationView {
            ZStack{
                Color.customDarkBlue.ignoresSafeArea(.all)
            VStack{
                List{
                    ForEach(skillVM.skills){ skill in
                        HStack{
                            Text(skill.name)
                            Spacer()
                            Text("Level \(skill.exp)")
                        }
                        .foregroundStyle(Color.white)
                        .padding(.vertical, 8)
                        .onTapGesture {
                            selectedSkill = skill
                            showActionSheet = true
                            
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.customNavyBlue)
                            .padding(.vertical, 2))
                }
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
            }
            .sheet(isPresented: $showSkillTemplateSheet) {
                    SkillTemplateSheet(kidID: kidID, skillVM: skillVM)
                            .presentationDetents([.height(750)])
                            .presentationDragIndicator(.hidden)
                    }
                
            // MARK: Fetching Factors
            .onAppear {
                skillVM.fetchSkills(selectedKidID: kidID)
            }
            }

        }
        // MARK: Navigation ToolBar
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) { // Places the button on the right
                Button {
                    showSkillTemplateSheet = true
                } label: {
                    Image("add")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                }
            }
            ToolbarItem(placement: .principal) { // Places the text in the center
                Text("Skills")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        
        
    }
}
        
        
      


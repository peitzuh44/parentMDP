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
    
    @ObservedObject var kidVM = KidViewModel()
    @State private var selectedSkill: SkillModel?
    @State private var showActionSheet = false
    @State private var showSkillTemplateSheet = false
    @State private var showAddSkillSheet = false
    func fetchAllSkills() {
        let config = FetchSkillsConfig(
            kidID: kidID,
            criteria: [
                
            ],
            sortOptions: [
                .exp(ascending: false)
            ],
            limit: nil)
        kidVM.fetchSkills(withConfig: config)
    }
    
    
    // MARK: Body
    var body: some View {
        NavigationView {
            ZStack{
                Color.customDarkBlue.ignoresSafeArea(.all)
            VStack{
                List{
                    ForEach(kidVM.skills){ skill in
                        let (level, progress) = calculateLevelAndProgress(forExp: skill.exp)
                        SkillItem(skill: skill, text: skill.name, level: level, progress: CGFloat(progress))
                        .onTapGesture {
                            selectedSkill = skill
                            showActionSheet = true
                            
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.customNavyBlue)
                            .padding(.vertical, 4))
                }
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
            }
            .sheet(isPresented: $showSkillTemplateSheet) {
                SkillTemplateSheet(kidID: kidID, kidVM: kidVM, showAddSkillSheet: $showAddSkillSheet)
                            .presentationDetents([.height(750)])
                            .presentationDragIndicator(.hidden)
                    }
            .sheet(isPresented: $showAddSkillSheet, content: {
                AddSkillSheet(kidID: kidID)
            })
                
            // MARK: Fetching Factors
            .onAppear {
                fetchAllSkills()
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
        
        
      


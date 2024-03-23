//
//  SkillPicker.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/3/23.
//

import SwiftUI

struct SkillPicker: View {
    @ObservedObject var kidVM: KidViewModel
    var selectedKidID: String
    @Binding var selectedSkills: [String]? // IDs of selected skills
    @Environment(\.presentationMode) var presentationMode

    func fetchAllSkills() {
        let config = FetchSkillsConfig(
            kidID: selectedKidID,
            criteria: [],
            sortOptions: [.exp(ascending: false)],
            limit: nil) // Adjusted to remove limit, or set as desired
        kidVM.fetchSkills(withConfig: config)
    }

    var body: some View {
        ZStack {
            Color.customNavyBlue.ignoresSafeArea(.all)
            VStack(alignment: .leading) {
                Text("SELECT CATEGORY")
                    .foregroundColor(.white)
                    .font(.callout)
                    .padding(.horizontal, 10)
                
                ForEach(kidVM.skills, id: \.id) { skill in
                    Button(action: {
                        if let index = self.selectedSkills?.firstIndex(of: skill.id) {
                            self.selectedSkills?.remove(at: index)
                        } else {
                            self.selectedSkills?.append(skill.id)
                        }
                    }) {
                        HStack {
                            Text(skill.name)
                                .foregroundColor(.white)
                            Spacer()
                            if self.selectedSkills?.contains(skill.id) ?? false {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.green)
                            }
                                              }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 24)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.customDarkBlue))
                    }
                }
                .padding(.horizontal, 10)
            }
            .onAppear {
                fetchAllSkills()
            }
        }

    }

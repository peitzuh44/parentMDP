//
//  SkillViewModel.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/27.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class SkillViewModel: ObservableObject {
    // MARK: Properties

    @Published var skillTemplates: [SkillTemplateModel] = []
    @Published var skills: [SkillModel] = []
    private let db = Firestore.firestore()
    let currentUserID = Auth.auth().currentUser?.uid ?? ""

    // MARK: Fetch Skills Template
    func fetchSkillTemplates(category: String){
        db.collection("skillTemplates")
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(String(describing: error?.localizedDescription))")
                    return
                }

                self?.skillTemplates = documents.compactMap { doc -> SkillTemplateModel? in
                    try? doc.data(as: SkillTemplateModel.self)
                }
            }
        
    }
    
    // MARK: Fetch Skills (by kid)
    func fetchSkills(selectedKidID: String){
        db.collection("skills")
            .whereField("createdBy", isEqualTo: currentUserID)
            .whereField("kid", isEqualTo: selectedKidID)
            // determine the order later
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(String(describing: error?.localizedDescription))")
                    return
                }

                self?.skills = documents.compactMap { doc -> SkillModel? in
                    try? doc.data(as: SkillModel.self)
                }
            }
        
    }
    
    
    // MARK: Add Skills From Template
    func addSkillFromTemplate(selectedKidID: String, template: SkillTemplateModel){
        
        let newSkillRef = db.collection("skills").document()
        let skillID = newSkillRef.documentID
        let skill = SkillModel(id: skillID, name: template.name, category: template.category, createdBy: currentUserID, kid: selectedKidID, exp: 0, relatedChallenges: [""], completedChallenges: [""])
  
        do {
            try db.collection("skills").document(skillID).setData(from: skill)
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    
    // MARK: Create New Skill
    func createCustomizeSkill(forUserID userID: String, selectedKidID: String, name: String, category: String){
        let newSkillRef = db.collection("skills").document()
        let skillID = newSkillRef.documentID
        let skill = SkillModel(id: skillID, name: name, category: category, createdBy: currentUserID, kid: selectedKidID, exp: 0, relatedChallenges: [""], completedChallenges: [""])
        do {
            try db.collection("skills").document(skillID).setData(from: skill)
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    
    // MARK: Delete Skills
    func deleteSkill(skillID: String){
        db.collection("skills").document(skillID).delete { error in
            if let error = error {
                print("Error removing skill document: \(error)")
            } else {
                print("skill document successfully removed!")
            }
        }
        
    }
    
    // MARK: Update skill
    func updateSkill(updatedSkill: SkillModel){
        let docRef = db.collection("skills").document(updatedSkill.id)
        let updateData: [String: Any] = [
            "name": updatedSkill.name
        ]

        docRef.updateData(updateData) { error in
            if let error = error {
                print("Error updating skill: \(error)")
            } else {
                print("Skill successfully updated")
            }
        }
        
        
    }
    
}

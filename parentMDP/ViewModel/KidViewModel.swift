//
//  KidViewModel.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/19.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

// MARK: Fetch Skills Configuration
struct FetchSkillsConfig {
    let kidID: String
    let criteria: [Criteria]
    let sortOptions: [SortOption]
    let limit: Int?
    
    enum Criteria {
        case createdBy(String)
        
    }
    
    enum SortOption {
        case exp(ascending: Bool)
        // Add other sort options as needed
    }
}


class KidViewModel: ObservableObject {
    @Published var kids: [KidModel] = []
    @Published var skills: [SkillModel] = []
    @Published var skillTemplates: [SkillTemplateModel] = []
    private var listeners: [ListenerRegistration] = []


    private let db = Firestore.firestore()
    let currentUserID = Auth.auth().currentUser?.uid ?? ""

    
    // MARK: Fetch Kids
    // function that fetches kids from the database (only the user's kid)
    func fetchKids() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        db.collection("kids")
            .whereField("parentID", isEqualTo: userID)
            .order(by: "timeCreated", descending: false)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(String(describing: error?.localizedDescription))")
                    return
                }
                
                // Map the documents to your data model
                let kids = documents.compactMap { doc -> KidModel? in
                    try? doc.data(as: KidModel.self)
                }
                
                // Dispatch the UI update on the main thread
                DispatchQueue.main.async {
                    self?.kids = kids
                }
            }
    }

    
    
    // MARK: Add kids
    // function that adds kids to your database given a name, gender, and birthdate
    func addKids(name: String, gender: String, birthdate: Date) {
        // Check if the current user has logged in or not
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        // Fetch the current user's parentCode from the users collection
        db.collection("users").document(currentUserID).getDocument { [weak self] documentSnapshot, error in
            guard let snapshot = documentSnapshot, error == nil else {
                print("Error fetching user details: \(error?.localizedDescription ?? "unknown error")")
                return
            }

            if let userData = snapshot.data(), let self = self {
                let parentID = currentUserID
                // Parent Code Fetched
                let myParent = userData["parentCode"] as? String ?? ""

                // Proceed to add the kid with the fetched parentID and myParent
                self.proceedToAddKids(name: name, gender: gender, birthdate: birthdate, parentID: parentID, myParent: myParent)
            }
        }
    }
    
    // Function that adds the kids to the firebase
    private func proceedToAddKids(name: String, gender: String, birthdate: Date, parentID: String, myParent: String) {
        let newKidRef = db.collection("kids").document()
        let kidID = newKidRef.documentID
        let kid = KidModel(id: kidID, timeCreated: Date(), name: name, gender: gender, birthdate: birthdate, parentID: parentID, myParent: myParent, avatarImage: "avatar1", health: 0, mental: 0, social: 0, intelligence: 0, coinBalance: 0, gemBalance: 0)
        
        do {
            try newKidRef.setData(from: kid)
        } catch let error {
            print("Error writing kid to Firestore: \(error)")
        }
    }

    
    // MARK: Update Kids
    func updateKid(updatedKid: KidModel) {
        let docRef = db.collection("kids").document(updatedKid.id)
        
        let updateData: [String: Any] = [
            "name": updatedKid.name,
            "gender": updatedKid.gender,
            "birthdate": updatedKid.birthdate
        ]
        docRef.updateData(updateData) { error in
            if let error = error {
                print("Error updating kid: \(error)")
            } else {
                print("Kid successfully updated")
                // You could perform additional tasks here, like notifying the user of the success
            }
        }
    }
    
    // MARK: Delete Kids
    func deleteKid(kidID: String) {
        db.collection("kids").document(kidID).delete { error in
            if let error = error {
                print("Error removing kid document: \(error)")
            } else {
                print("One-off kid document successfully removed!")
            }
        }
    }
    
    // Calculate Age
    func calculateAge(birthdate: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthdate, to: now)
        return ageComponents.year!
    }
    

}

// MARK: Skills Subcollection
extension KidViewModel {
    // Add skill to a specific kid
    func addSkillToKid(name: String, category: String, kidID: String) {
        // Reference to the new skill document in the skills subcollection of the specified kid
        let newSkillRef = db.collection("kids").document(kidID).collection("skills").document()
        
        // Since newSkillRef generates a new document reference, it already has a unique documentID
        let skillID = newSkillRef.documentID
        
        // Creating the skill model with the generated skillID and other parameters
        let skill = SkillModel(id: skillID, name: name, category: category, createdBy: currentUserID, kid: kidID, exp: 0, completedChallenges: [""])
        
        do {
            // Correcting the path to use newSkillRef for adding the document to the subcollection
            try newSkillRef.setData(from: skill)
        } catch let error {
            print("Error: \(error)")
        }
    }

    func fetchSkills(withConfig config: FetchSkillsConfig) {
        var query: Query = db.collection("kids").document(config.kidID).collection("skills")
        
        // Apply criteria
        for criterion in config.criteria {
            switch criterion {
            case .createdBy(let userID):
                query = query.whereField("createdBy", isEqualTo: userID)
            }
        }
        
        // Apply sorting
        for sortOption in config.sortOptions {
            switch sortOption {
            case .exp(let ascending):
                query = query.order(by: "exp", descending: !ascending)
            }
        }
        
        // Apply limit
        if let limit = config.limit {
            query = query.limit(to: limit)
        }
        
        // Execute query with a real-time listener
        let listener = query.addSnapshotListener { [weak self] querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "")")
                return
            }
            
            let skills = documents.compactMap { doc -> SkillModel? in
                try? doc.data(as: SkillModel.self)
            }
            
            DispatchQueue.main.async {
                  // Assuming `skills` is an @Published property you want to update
                self?.skills = documents.compactMap { doc -> SkillModel? in
                      try? doc.data(as: SkillModel.self)
                  }
              }
          }
        
        // Store the listener if you need to remove it later
        self.listeners.append(listener)
    }

    
    //Update Skills
    func updateSkillForKid(kidId: String, skill: SkillModel) {
        let skillRef = db.collection("kids").document(kidId).collection("skills").document(skill.id)

        // Create an update dictionary from the skill model.
        // Only include fields you want to update.
        let updateData: [String: Any] = [
            "name": skill.name,
            "category": skill.category,
        ]
        skillRef.updateData(updateData) { error in
            if let error = error {
                print("Error updating skill: \(error.localizedDescription)")
            } else {
                print("Skill successfully updated!")
            }
        }
    }
    
    //Delete Skills
    func deleteSkillForKid(kidId: String, skillId: String) {
        let skillRef = db.collection("kids").document(kidId).collection("skills").document(skillId)

        skillRef.delete() { error in
            if let error = error {
                print("Error removing skill: \(error.localizedDescription)")
            } else {
                print("Skill successfully removed!")
                self.skills.removeAll { $0.id == skillId }
            }
        }
    }
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
    // MARK: Add Skills From Template
    func addSkillFromTemplate(selectedKidID: String, template: SkillTemplateModel){
        let newSkillRef = db.collection("skills").document()
        let skillID = newSkillRef.documentID
        let skill = SkillModel(id: skillID, name: template.name, category: template.category, createdBy: currentUserID, kid: selectedKidID, exp: 0, completedChallenges: [""])
  
        do {
            try db.collection("skills").document(skillID).setData(from: skill)
        } catch let error {
            print("Error: \(error)")
        }
    }

}


func calculateLevelAndProgress(forExp exp: Int) -> (level: Int, progress: Double) {
    // Constants for the logarithmic function
    let base = 2.0 // Adjust based on how quickly you want users to level up
    let coefficient = 100.0 // Base experience required for leveling up
    
    // Ensure exp is always greater than 0
    guard exp > 0 else { return (1, 0.0) } // Return level 1 and 0% progress if exp <= 0
    
    // Logarithmic function to calculate level
    let level = max(log(Double(exp) / coefficient) / log(base), 0) // Ensure level is not negative
    let currentLevel = Int(level)
    let nextLevelExp = coefficient * pow(base, Double(currentLevel + 1))
    let previousLevelExp = coefficient * pow(base, Double(currentLevel))
    
    // Calculate progress towards the next level
    let progress = (exp > Int(coefficient)) ? Double(exp - Int(previousLevelExp)) / Double(nextLevelExp - previousLevelExp) : 0.0
    
    return (currentLevel + 1, max(0, min(progress * 100, 100))) // Ensure progress is between 0 and 100
}


func calculateLevel(exp: Int) -> Int {
    let base: Double = 10 // Adjust base according to desired difficulty curve
    return 1 + Int(log(Double(exp) + 1) / log(base))
}

func calculateProgress(exp: Int) -> Double {
    let currentLevel = calculateLevel(exp: exp)
    let expForCurrentLevel = Int(pow(10, Double(currentLevel - 1))) - 1
    let expForNextLevel = Int(pow(10, Double(currentLevel))) - 1
    let progress = Double(exp - expForCurrentLevel) / Double(expForNextLevel - expForCurrentLevel)
    return progress * 100 // Convert to percentage
}

//
//  ChallengeViewModel.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/25.
//
import FirebaseAuth
import FirebaseFirestore

//MARK: Challenge Fetching Configurations

struct FetchChallengesConfig {
    let userID: String
    let status: String
    let selectedKidID: String
    let criteria: [Criteria]
    let sortOptions: [SortOption]
    let limit: Int?
    
    enum Criteria {
        case createdBy(String)
        case assignTo(String)
        case assignedOrSelfSelected(String)
        case dueDateNotPassed
        case status(String)
        case dateCompleted
    }
    
    enum SortOption {
        case dueDate(ascending: Bool)
        case timeCreated(ascending: Bool)
        case dateCompleted(ascending: Bool)
        
    }
    
}

class ChallengeViewModel: ObservableObject {
    // MARK: Properties
    @Published var challenges: [ChallengeModel] = []
    private let db = Firestore.firestore()
    let currentUserID = Auth.auth().currentUser?.uid ?? ""
    
    // MARK: Fetch Challenges
    func fetchChallenges(withConfig config: FetchChallengesConfig) {
        var query: Query = db.collection("challenges")
        // Apply criteria
        for criterion in config.criteria {
            switch criterion {
            case .createdBy(let userID):
                query = query.whereField("createdBy", isEqualTo: userID)
            case .assignTo(let kidID):
                query = query.whereField("assignTo", isEqualTo: kidID)
            case .assignedOrSelfSelected(let value):
                query = query.whereField("assignedOrSelfSelected", isEqualTo: value)
            case .dueDateNotPassed:
                query = query.whereField("due", isGreaterThan: Date())
            case .status(let status):
                query = query.whereField("status", isEqualTo: status)
            case .dateCompleted:
                query = query.whereField("dateCompleted", isGreaterThan: Date(timeIntervalSince1970: 0))
            }
        }
        
        // Apply sorting
        for sortOption in config.sortOptions {
            switch sortOption {
            case .dueDate(let ascending):
                query = query.order(by: "due", descending: !ascending)
            case .timeCreated(let ascending):
                query = query.order(by: "timeCreated", descending: !ascending)
            case .dateCompleted(let ascending):
                query = query.order(by: "dateCompleted", descending: !ascending)
            }
        }
        
        // Apply limit
        if let limit = config.limit {
            query = query.limit(to: limit)
        }
        
        // Execute query
        query.addSnapshotListener { [weak self] querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error?.localizedDescription))")
                return
            }

            self?.challenges = documents.compactMap { doc -> ChallengeModel? in
                try? doc.data(as: ChallengeModel.self)
            }
        }
    }
    
    // MARK: Create Challenges
    func createChallenge(name: String, description: String, createdBy: String, assignTo: String, difficulty: String, due: Date, assignedOrSelfSelected: String, reward: Int, skills: [String]?, dateCompleted: Date?){
        let db = Firestore.firestore()
        let newChallengeRef = db.collection("challenges").document()
        let challengeID = newChallengeRef.documentID
        let challenge =
        ChallengeModel(id: challengeID, name: name, description: description, comment: "no comment", timeCreated: Date(), createdBy: createdBy, assignTo: assignTo, difficulty: difficulty, reward: reward, due: due, assignedOrSelfSelected: assignedOrSelfSelected, relatedSkills: skills, status: "ongoing", dateCompleted: Date())
        do {
            try db.collection("challenges").document(challengeID).setData(from: challenge)
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    // MARK: Delete Challenges
    func deleteChallenge(challengeID: String) {
        db.collection("challenges").document(challengeID).delete { error in
            if let error = error {
                print("Error removing challenge document: \(error)")
            } else {
                print("One-off challenge document successfully removed!")
            }
        }
    }
    
    
    // MARK: Update Challenge
    func updateChallenge(updatedChallenge: ChallengeModel) {
        let docRef = db.collection("challenges").document(updatedChallenge.id)
        
        let updateData: [String: Any] = [
            "name": updatedChallenge.name,
            "difficulty": updatedChallenge.difficulty, // rarity is already a String
            "assignTo": updatedChallenge.assignTo,
            "reward": updatedChallenge.reward,
            "due": updatedChallenge.due
        ]
        
        docRef.updateData(updateData) { error in
            if let error = error {
                print("Error updating reward: \(error)")
            } else {
                print("Reward successfully updated")
                // You could perform additional tasks here, like notifying the user of the success
            }
        }
    }
    
}


extension ChallengeViewModel {
    
// MARK: Mark Complete / Update Reward
    func completeChallengeAndUpdateKidGem(challenge: ChallengeModel, comment: String? = nil, dateComplete: Date) {
            // First, mark the challenge as complete.
            let amountToAdd = challenge.reward

            // Pass the comment parameter to the markChallengeAsComplete function
            markChallengeAsComplete(challengeID: challenge.id, comment: comment, dateCompleted: dateComplete) { [self] in
                if challenge.assignedOrSelfSelected == "assigned" {
                    self.updateKidGemBalance(kidID: challenge.assignTo, gemToAdd: amountToAdd)
                } else if challenge.assignedOrSelfSelected == "self-selected" {
                    self.updateKidGoldBalance(kidID: challenge.assignTo, goldToAdd: amountToAdd)
                }
                let expToAdd = self.expForChallengeDifficulty(challenge.difficulty)

                // Update the experience for each realted skill
                if !challenge.relatedSkills!.isEmpty {
                    for skillID in challenge.relatedSkills! {
                        self.updateSkillExp(kidID: challenge.assignTo, skillID: skillID, expToAdd: expToAdd)
                    }
                }

            }
        }
    // Helper function to determine exp based on difficulty
    private func expForChallengeDifficulty(_ difficulty: String) -> Int {
        switch difficulty {
        case "Easy":
            return 50
        case "Medium":
            return 100
        case "Hard":
            return 200
        default:
            return 0 // No exp for undefined difficulty
        }
    }

    // MARK: Update Skill Experience
    private func updateSkillExp(kidID: String, skillID: String, expToAdd: Int) {
        // Adjusted reference to point to the skill within the kids collection
        let skillRef = db.collection("kids").document(kidID).collection("skills").document(skillID)

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let skillDocument: DocumentSnapshot
            do {
                try skillDocument = transaction.getDocument(skillRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }

            // Ensure the document contains the 'exp' field
            guard let oldExp = skillDocument.data()?["exp"] as? Int else {
                let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [
                    NSLocalizedDescriptionKey: "Unable to retrieve exp from snapshot \(skillDocument)"
                ])
                errorPointer?.pointee = error
                return nil
            }

            // Update the 'exp' field with the new value
            transaction.updateData(["exp": oldExp + expToAdd], forDocument: skillRef)
            return nil
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                print("Transaction successfully committed!")
            }
        }
    }



        // No changes needed here, but included for context
    private func markChallengeAsComplete(challengeID: String, comment: String?, dateCompleted: Date, completion: @escaping () -> Void) {
            let challengeRef = db.collection("challenges").document(challengeID)
            challengeRef.updateData(
                ["status": "complete",
                 "comment": comment ?? "testing",
                 "dateCompleted": dateCompleted
                ]
            ) { error in
                if let error = error {
                    print("Error updating challenge status: \(error)")
                } else {
                    print("Challenge marked as complete")
                    completion()
                }
            }
        }

// MARK: Update Gem Balance
private func updateKidGemBalance(kidID: String, gemToAdd: Int) {
        let kidRef = db.collection("kids").document(kidID)
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let kidDocument: DocumentSnapshot
            do {
                try kidDocument = transaction.getDocument(kidRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            guard let oldGemBalance = kidDocument.data()?["gemBalance"] as? Int else {
                let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [
                    NSLocalizedDescriptionKey: "Unable to retrieve gem balance from snapshot \(kidDocument)"
                ])
                errorPointer?.pointee = error
                return nil
            }
            transaction.updateData(["gemBalance": oldGemBalance + gemToAdd], forDocument: kidRef)
            return nil
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                print("Transaction successfully committed!")
            }
        }
    }
    // MARK: Update coin balance
    private func updateKidGoldBalance(kidID: String, goldToAdd: Int) {
            let kidRef = db.collection("kids").document(kidID)
            db.runTransaction({ (transaction, errorPointer) -> Any? in
                let kidDocument: DocumentSnapshot
                do {
                    try kidDocument = transaction.getDocument(kidRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                guard let oldGoldBalance = kidDocument.data()?["goldBalance"] as? Int else {
                    let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [
                        NSLocalizedDescriptionKey: "Unable to retrieve gem balance from snapshot \(kidDocument)"
                    ])
                    errorPointer?.pointee = error
                    return nil
                }
                transaction.updateData(["goldBalance": oldGoldBalance + goldToAdd], forDocument: kidRef)
                return nil
            }) { (object, error) in
                if let error = error {
                    print("Transaction failed: \(error)")
                } else {
                    print("Transaction successfully committed!")
                }
            }
        }
}


// MARK: TODOs
/*
 1. refractor fetch challenge function - for different fetching conditions
 */

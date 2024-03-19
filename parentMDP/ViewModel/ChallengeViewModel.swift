//
//  ChallengeViewModel.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/25.
//
import FirebaseAuth
import FirebaseFirestore


class ChallengeViewModel: ObservableObject {
    // MARK: Properties
    @Published var challenges: [ChallengeModel] = []
    private let db = Firestore.firestore()
    let currentUserID = Auth.auth().currentUser?.uid ?? ""

    
    // MARK: Fetch Challenges
    func fetchChallenges(forUserID userID: String, selectedKidID: String, assignedOrSelfSelected: String) {
        
        db.collection("challenges")
            .whereField("createdBy", isEqualTo: userID)
            .whereField("assignTo", isEqualTo: selectedKidID)
            .whereField("assignedOrSelfSelected", isEqualTo: assignedOrSelfSelected)
            .order(by: "due", descending: false)
            .order(by: "timeCreated", descending: false)
            .addSnapshotListener { [weak self] querySnapshot, error in
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
    func createChallenge(name: String, description: String, createdBy: String, assignTo: String, difficulty: String, due: Date, assignedOrSelfSelected: String, reward: Int, skills: [String], dateCompleted: Date?){
        let db = Firestore.firestore()
        let newChallengeRef = db.collection("challenges").document()
        let challengeID = newChallengeRef.documentID
        let challenge =
        ChallengeModel(id: challengeID, name: name, description: description, timeCreated: Date(), createdBy: createdBy, assignTo: assignTo, difficulty: difficulty, reward: reward, due: due, assignedOrSelfSelected: assignedOrSelfSelected, relatedSkills: skills, status: "ongoing")
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
    
    
    
    
}


extension ChallengeViewModel {
    
// MARK: Mark Complete / Update Reward
func completeChallengeAndUpdateKidGem(challenge: ChallengeModel) {
    // First, mark the challenge as complete.
    let amountToAdd = challenge.reward
    
    
    markChallengeAsComplete(challengeID: challenge.id) { [self] in
        if challenge.assignedOrSelfSelected == "assigned" {
            self.updateKidGemBalance(kidID: challenge.assignTo, gemToAdd: amountToAdd)

        }
        if challenge.assignedOrSelfSelected == "self-selected" {
            self.updateKidGoldBalance(kidID: challenge.assignTo, goldToAdd: amountToAdd)
        }
    }
}
// MARK: Mark As Complete
private func markChallengeAsComplete(challengeID: String, completion: @escaping () -> Void) {
        let challengeRef = db.collection("challenges").document(challengeID)
        challengeRef.updateData(["status": "complete"]) { error in
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

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

class KidViewModel: ObservableObject {
    @Published var kids: [KidModel] = []
    private let db = Firestore.firestore()

    
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
            "gender": updatedKid.gender, // rarity is already a String
            "birthdate": updatedKid.birthdate
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
    func calculateAge(birthday: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        return ageComponents.year!
    }
}


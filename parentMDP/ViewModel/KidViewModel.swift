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

    
    //fetch kids
    func fetchKids() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        db.collection("kids")
            .whereField("parentID", isEqualTo: userID)
            .order(by: "createdAt", descending: false)
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

    
    // add kids
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

    private func proceedToAddKids(name: String, gender: String, birthdate: Date, parentID: String, myParent: String) {
        let newKidRef = db.collection("kids").document()
        let kidID = newKidRef.documentID
        let kid = KidModel(id: kidID, 
                           name: name,
                           gender: gender,
                           birthdate: birthdate,
                           parentID: parentID,
                           myParent: myParent,
                           createdAt: Date(), 
                           avatarImage: "",
                           exp: 0,
                           level: 0,
                           avatarClass: "",
                           hp: 0,
                           attack: 0,
                           defense: 0,
                           magic: 0,
                           pointBalance: 0,
                           goldBalance: 0,
                           gemBalance: 0)
        
        do {
            try newKidRef.setData(from: kid)
        } catch let error {
            print("Error writing kid to Firestore: \(error)")
        }
    }

    
    //update kids
    
    //delete kids
    
    //calculate age
    
    func calculateAge(from birthdate: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthdate, to: now)
        let age = ageComponents.year!
        return age
    }


}


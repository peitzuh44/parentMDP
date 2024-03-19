//
//  RewardViewModel.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/25.
//

import SwiftUI

import FirebaseAuth
import FirebaseFirestore

class RewardViewModel: ObservableObject {
    @Published var rewards: [RewardModel] = []
    @Published var purchasedReward: [RewardPurchaseModel] = []
    private let db = Firestore.firestore()
    
    
    //MARK: Fetch Rewards
    func fetchRewards(){
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        db.collection("rewards")
            .whereField("createdBy", isEqualTo: userID)
            .order(by: "timeCreated", descending: false)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(String(describing: error?.localizedDescription))")
                    return
                }
                
                // Map the documents to your data model
                let rewards = documents.compactMap { doc -> RewardModel? in
                    try? doc.data(as: RewardModel.self)
                }
                
                // Dispatch the UI update on the main thread
                DispatchQueue.main.async {
                    self?.rewards = rewards
                }
            }
    }
    
    func fetchPurchaseRecord(forUserID userID: String){
        db.collection("purchaseRewards")
            .whereField("createdBy", isEqualTo: userID)
            .whereField("status", isEqualTo: "not yet redeem")
            .order(by: "timePurchased", descending: false)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(String(describing: error?.localizedDescription))")
                    return
                }

                self?.purchasedReward = documents.compactMap { doc -> RewardPurchaseModel? in
                    try? doc.data(as: RewardPurchaseModel.self)
                }
            }
    }
    
    
    //MARK: Delete Reward
    func deleteReward(rewardID: String) {
        db.collection("rewards").document(rewardID).delete { error in
            if let error = error {
                print("Error removing reward document: \(error)")
            } else {
                print("One-off reward document successfully removed!")
            }
        }
    }
    
    // MARK: Create Reward
    func createReward(name: String, rarity: String, price: Int, createdBy: String){
        let newRewardRef = db.collection("rewards").document()
        let rewardID = newRewardRef.documentID
        let reward = RewardModel(id: rewardID, name: name, createdBy: createdBy, timeCreated: Date(), rarity: rarity, price: price)
  
        do {
            try db.collection("rewards").document(rewardID).setData(from: reward)
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    // MARK: Update Reward
    func updateReward(updatedReward: RewardModel) {
        let docRef = db.collection("rewards").document(updatedReward.id)
        
        let updateData: [String: Any] = [
            "name": updatedReward.name,
            "rarity": updatedReward.rarity, // rarity is already a String
            "price": updatedReward.price
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


extension RewardViewModel {
    // MARK: Purchase Reward
    func purchaseRewardAndUpdateKidGold(reward: RewardModel, purchasedBy: String) {
        
        let kidRef = db.collection("kids").document(purchasedBy)
        
        kidRef.getDocument { [self] (document, error) in
               if let document = document, document.exists {
                   // The document was found
                   guard let documentData = document.data() else { return }
                   
                   // Assuming `gemBalance` is a field within the document
                   // Make sure this field name matches what's in your Firestore document
                   if let gemBalance = documentData["gemBalance"] as? Int {
                       print("Gem Balance: \(gemBalance)")
                       
                       if gemBalance >= reward.price {
                           addPurchaseRecord(reward: reward, purchasedBy: purchasedBy)
                           deductKidGemBalance(kidID: purchasedBy, gemToDeduct: reward.price)
                       }
                       
                   } else {
                       print("Gem Balance is not available or not an Int.")
                   }
               } else if let error = error {
                   print("Error getting document: \(error)")
               } else {
                   print("Document does not exist")
               }
           }


    }

    func addPurchaseRecord(reward: RewardModel, purchasedBy: String){
        let newPurchaseRewardRef = db.collection("purchaseRewards").document()
        let purchaseRewardID = newPurchaseRewardRef.documentID
        let purchaseReward = RewardPurchaseModel(
            id: purchaseRewardID,
            name: reward.name,
            timePurchased: Date(),
            createdBy: reward.createdBy,
            status: "not yet redeem",
            purchasedBy: purchasedBy)
  
        do {
            try db.collection("purchaseRewards").document(purchaseRewardID).setData(from: purchaseReward)
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    // MARK: Mark reward as redeemed
    func markRewardAsRedeemed(purchasedReward: RewardPurchaseModel){
        let purchasedRewardID = purchasedReward.id
        let purchaseRewardRef = db.collection("purchaseRewards").document(purchasedRewardID)
        purchaseRewardRef.updateData(["status":"redeemed"]){ error in
            if let error = error {
                print("Error updating challenge status: \(error)")
            } else {
                print("Challenge marked as complete")
            }
        }
    }
    
    
    
// MARK: Balance Calculation
private func deductKidGemBalance(kidID: String, gemToDeduct: Int) {
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
            transaction.updateData(["gemBalance": oldGemBalance - gemToDeduct], forDocument: kidRef)
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
